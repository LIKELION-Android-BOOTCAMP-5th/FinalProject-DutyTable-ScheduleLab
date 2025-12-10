import 'package:dio/dio.dart'; // Dio 라이브러리 임포트
import 'package:flutter/foundation.dart'; // debugPrint를 위해 추가
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../main.dart';
import '../models/calendar_member_model.dart';
import '../models/calendar_model.dart';

class CalendarDataSource {
  /// 싱글턴
  static final CalendarDataSource _shared = CalendarDataSource();
  static CalendarDataSource get shared => _shared;

  static const String _baseUrl = 'https://eexkppotdipyrzzjakur.supabase.co';

  static final String apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  // 인스턴스 초기화
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'apikey': apiKey, 'Content-Type': 'application/json'},
    ),
  );

  /// 개인 캘린더 가져오기
  Future<CalendarModel> fetchPersonalCalendar() async {
    final userId = supabase.auth.currentUser?.id ?? "";

    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': '*,calendars_user_id_fkey(nickname)',
        'user_id': 'eq.$userId',
        'type': 'eq.personal',
        'limit': 1,
      },
    );

    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> jsonData = response.data;

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
    final response = await _dio.get(
      '/rest/v1/calendar_members',
      queryParameters: {
        'select': '*,users(nickname)',
        'calendar_id': 'eq.$calendarId',
      },
    );

    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> jsonData = response.data;

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

    // 1단계: 현재 유저가 포함된 캘린더 ID 목록 가져오기
    Response filterResponse;
    try {
      filterResponse = await _dio.get(
        '/rest/v1/calendar_members',
        queryParameters: {
          'select': 'calendar_id,calendars(type)',
          'user_id': 'eq.$userId',
          'calendars.type': 'eq.$type',
        },
      );
    } on DioException catch (e) {
      debugPrint('1단계 DioException: ${e.message}');
      throw Exception('Failed to filter calendar IDs: ${e.message}');
    }

    if (filterResponse.statusCode != 200 || !(filterResponse.data is List)) {
      throw Exception(
        'Failed to filter calendar IDs: Status ${filterResponse.statusCode}, Body: ${filterResponse.data}',
      );
    }

    final List<dynamic> idData = filterResponse.data;
    if (idData.isEmpty) {
      return [];
    }

    final List<int> calendarIds = idData
        .map((item) => item['calendar_id'] as int?)
        .whereType<int>()
        .toList();

    if (calendarIds.isEmpty) {
      return [];
    }
    final String idsQuery = calendarIds.join(',');

    // 2단계: 필터링된 ID 목록으로 캘린더 기본 데이터 목록 가져오기
    Response calendarResponse;
    try {
      calendarResponse = await _dio.get(
        '/rest/v1/calendars',
        queryParameters: {
          'select': '*,calendars_user_id_fkey(nickname)',
          'id': 'in.($idsQuery)',
          'type': 'eq.$type',
        },
      );
    } on DioException catch (e) {
      debugPrint('2단계 DioException: ${e.message}');
      throw Exception('Failed to load calendars: ${e.message}');
    }

    if (calendarResponse.statusCode != 200 ||
        !(calendarResponse.data is List)) {
      throw Exception(
        'Failed to load calendars: Status ${calendarResponse.statusCode}',
      );
    }

    final List<dynamic> calendarJsonData = calendarResponse.data;
    final List<CalendarModel> calendars = calendarJsonData
        .map(
          (jsonItem) =>
              CalendarModel.fromJson(jsonItem as Map<String, dynamic>),
        )
        .toList();

    // 3단계: 각 캘린더의 멤버 목록을 비동기적으로 가져와 병합
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
