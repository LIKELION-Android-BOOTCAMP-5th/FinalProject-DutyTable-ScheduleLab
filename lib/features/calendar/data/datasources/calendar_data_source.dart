import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';
import '../models/calendar_member_model.dart';
import '../models/calendar_model.dart';

class CalendarDataSource {
  /// 싱글턴
  static final CalendarDataSource _shared = CalendarDataSource();
  static CalendarDataSource get shared => _shared;

  /// supabase apiKey
  static final apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  /// 개인 캘린더 정보 가져오기
  Future<CalendarModel> fetchPersonalCalendar() async {
    final userId = supabase.auth.currentUser?.id ?? "";

    final response = await http.get(
      Uri.parse(
        'https://eexkppotdipyrzzjakur.supabase.co/rest/v1/calendars?select=*,calendars_user_id_fkey(nickname)&user_id=eq.$userId&type=eq.personal&limit=1',
      ),
      headers: {'apikey': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        return CalendarModel.fromJson(jsonData.first as Map<String, dynamic>);
      } else {
        throw Exception('Calendar not found for user.');
      }
    } else {
      throw Exception('Failed to load calendar: Status ${response.statusCode}');
    }
  }

  /// 멤버 목록 가져오기
  Future<List<CalendarMemberModel>?> fetchCalendarMembers(
    int calendarId,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://eexkppotdipyrzzjakur.supabase.co/rest/v1/calendar_members?select=*,users(nickname)&calendar_id=eq.$calendarId',
      ),
      headers: {'apikey': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        return jsonData.map((jsonItem) {
          return CalendarMemberModel.fromJson(jsonItem as Map<String, dynamic>);
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception(
        'Failed to load calendar Member: Status ${response.statusCode}',
      );
    }
  }

  /// 공유 캘린더 목록 가져오기
  Future<List<CalendarModel>> fetchCalendarFinalList(String type) async {
    final userId = supabase.auth.currentUser?.id ?? "";

    // 현재 유저가 포함된 캘린더 ID 목록 가져오기
    final Uri filterUri = Uri.https(
      'eexkppotdipyrzzjakur.supabase.co',
      '/rest/v1/calendar_members',
      {
        'select': 'calendar_id,calendars(type)',

        'user_id': 'eq.$userId',

        'calendars.type': 'eq.$type',
      },
    );

    final filterResponse = await http.get(
      filterUri,
      headers: {'apikey': apiKey},
    );

    if (filterResponse.statusCode != 200) {
      throw Exception(
        'Failed to filter calendar IDs: Status ${filterResponse.statusCode}, Body: ${filterResponse.body}',
      );
    }

    final List<dynamic> idData = json.decode(filterResponse.body);
    if (idData.isEmpty) {
      return [];
    }

    final List<int> calendarIds = idData
        .map((item) => item['calendar_id'] as int)
        .toList();
    final String idsQuery = calendarIds.join(',');

    // 필터링된 ID 목록으로 캘린더 기본 데이터 목록 가져오기
    final Uri calendarUri =
        Uri.https('eexkppotdipyrzzjakur.supabase.co', '/rest/v1/calendars', {
          'select': '*,calendars_user_id_fkey(nickname)',
          'id': 'in.($idsQuery)',
          'type': 'eq.$type',
        });

    final calendarResponse = await http.get(
      calendarUri,
      headers: {'apikey': apiKey},
    );

    if (calendarResponse.statusCode != 200) {
      throw Exception(
        'Failed to load calendars: Status ${calendarResponse.statusCode}',
      );
    }

    final List<dynamic> calendarJsonData = json.decode(calendarResponse.body);
    final List<CalendarModel> calendars = calendarJsonData
        .map(
          (jsonItem) =>
              CalendarModel.fromJson(jsonItem as Map<String, dynamic>),
        )
        .toList();

    // 각 캘린더의 멤버 목록을 비동기적으로 가져와 병합
    final List<Future<List<CalendarMemberModel>?>> memberFutures = calendars
        .map((calendar) => fetchCalendarMembers(calendar.id))
        .toList();

    final List<List<CalendarMemberModel>?> allMembersLists = await Future.wait(
      memberFutures,
    );

    // 캘린더 모델에 멤버 목록 결합
    for (int i = 0; i < calendars.length; i++) {
      calendars[i].calendarMemberModel = allMembersLists[i];
    }

    return calendars;
  }
}
