import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../main.dart';
import '../models/calendar_member_model.dart';
import '../models/calendar_model.dart';

class CalendarDataSource {
  static final CalendarDataSource _shared = CalendarDataSource();
  static CalendarDataSource get shared => _shared;

  static const apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVleGtwcG90ZGlweXJ6empha3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzODcwNzksImV4cCI6MjA3NDk2MzA3OX0.HFGirj_JSIZB5bkgwm8CnQAqE9kBoRMOlcG8dl6-vyw';

  /// 캘린더 정보 가져오기
  Future<CalendarModel> fetchCalendar(String type) async {
    final userId = supabase.auth.currentUser?.id ?? "";

    final response = await http.get(
      Uri.parse(
        'https://eexkppotdipyrzzjakur.supabase.co/rest/v1/calendars?select=*,calendars_user_id_fkey(nickname),calendar_members(*,users(nickname))&user_id=eq.$userId&type=eq.$type',
      ),
      headers: {'apikey': apiKey},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        final Map<String, dynamic> jsonItem =
            jsonData.first as Map<String, dynamic>;

        return CalendarModel.fromJson(jsonItem);
      } else {
        throw Exception('Calendar not found for user.');
      }
    } else {
      throw Exception('Failed to load calendar: Status ${response.statusCode}');
    }
  }

  /// 캘린더 멤버 목록 가져오기
  Future<List<CalendarMemberModel>?> fetchCalendarMembers(
    int calendarId,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://eexkppotdipyrzzjakur.supabase.co/rest/v1/calendar_members?select=*&calendar_id=eq.$calendarId',
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
        throw Exception('Calendar Member not found.');
      }
    } else {
      throw Exception(
        'Failed to load calendar Member: Status ${response.statusCode}',
      );
    }
  }
}
