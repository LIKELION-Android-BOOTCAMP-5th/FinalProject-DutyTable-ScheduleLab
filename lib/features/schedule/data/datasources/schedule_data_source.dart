import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:dutytable/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/schedule_model.dart';

class ScheduleDataSource {
  ScheduleDataSource._();
  static final ScheduleDataSource instance = ScheduleDataSource._();

  final Dio _dio = DioClient.shared.dio;

  Future<List<DateTime>> fetchHolidays() async {
    const String googleApiKey = "AIzaSyChi09zyRm-cUUvRYsggxCUE6hxkzRf9is";
    const String calendarId =
        "ko.south_korea#holiday@group.v.calendar.google.com";

    final Uri uri = Uri.https(
      "www.googleapis.com",
      "/calendar/v3/calendars/$calendarId/events",
      {
        'key': googleApiKey,
        'timeMin': "${DateTime.now().year}-01-01T00:00:00Z",
        'timeMax': "${DateTime.now().year}-12-31T23:59:59Z",
        'singleEvents': 'true',
      },
    );

    try {
      final response = await Dio().getUri(uri);

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];

        final List<DateTime> holidays = items.map((item) {
          return DateTime.parse(item['start']['date']);
        }).toList();

        holidays.sort();

        return holidays;
      }

      return [];
    } on DioException catch (e) {
      print("❌ 구글 API 상세 에러: ${e.response?.data}");
      return [];
    } catch (e) {
      print("❌ 일반 에러: $e");
      return [];
    }
  }

  /// CREATE
  Future<void> addSchedule(List<Map<String, dynamic>> payloads) async {
    try {
      await _dio.post(
        '/rest/v1/schedules',
        data: payloads,
        options: Options(headers: {'Prefer': 'return=minimal'}),
      );
    } catch (e) {
      throw Exception("create 에러:  $e");
    }
  }

  /// READ
  /// 스케줄 단건 조회
  Future<ScheduleModel> fetchScheduleById(int scheduleId) async {
    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {'select': '*', 'id': 'eq.$scheduleId'},
    );

    if (response.statusCode == 200 &&
        response.data is List &&
        response.data.isNotEmpty) {
      return ScheduleModel.fromJson(response.data.first);
    } else {
      throw Exception('Failed to load schedule detail');
    }
  }

  /// 스케줄 조회
  Future<List<ScheduleModel>> fetchSchedules(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {'select': '*', 'calendar_id': 'eq.$calendarId'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load schedules");
    }
  }

  /// 내 일정 불러오기
  Future<List<ScheduleModel>> fetchMySchedules() async {
    final currentUserId = supabase.auth.currentUser?.id;
    final data = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': 'id',
        'user_id': 'eq.$currentUserId',
        'type': 'eq.personal',
      },
    );

    final List<dynamic> jsonData = data.data;

    if (jsonData.isEmpty) return [];

    final myCalendarId = jsonData.first['id'];

    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {'select': '*', 'calendar_id': 'eq.$myCalendarId'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load schedules");
    }
  }

  /// UPDATE
  /// 스케줄 수정
  Future<void> updateSchedule({
    required int scheduleId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      await _dio.patch(
        '/rest/v1/schedules',
        queryParameters: {'id': 'eq.$scheduleId'},
        data: payload,
      );
    } catch (e) {
      throw Exception("단건 수정 에러: $e");
    }
  }

  /// 반복 그룹 일괄 수정
  Future<void> updateSchedulesByGroupId({
    required String repeatGroupId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _dio.patch(
        '/rest/v1/schedules',
        queryParameters: {'repeat_group_id': 'eq.$repeatGroupId'},
        data: payload,
        options: Options(
          headers: {
            // 수정된 데이터를 결과로 받겠다고 명시
            'Prefer': 'return=representation',
          },
        ),
      );

      // 로그 확인: 수정된 데이터 리스트가 비어있다면 필터(id)가 잘못된 것입니다.
      print("✅ 수정된 데이터 수: ${(response.data as List).length}");
      print("✅ 수정된 데이터 상세: ${response.data}");
    } catch (e) {
      throw Exception("그룹 일괄 수정 에러: $e");
    }
  }

  /// DELETE
  /// 스케줄 삭제
  Future<void> deleteSchedules(int scheduleId) async {
    final response = await _dio.delete(
      '/rest/v1/schedules',
      queryParameters: {'id': 'eq.$scheduleId'},
    );

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception("Failed to load schedules");
    }
  }

  Future<void> deleteSchedulesByGroupId(String groupId) async {
    try {
      await _dio.delete(
        '/rest/v1/schedules',
        queryParameters: {'repeat_group_id': 'eq.$groupId'},
      );
    } catch (e) {
      throw Exception("그룹 일괄 삭제 에러: $e");
    }
  }

  Future<void> deleteAllSchedules(Set<String> scheduleIds) async {
    if (scheduleIds.isEmpty) return;

    final ids = scheduleIds.join(',');

    final response = await _dio.delete(
      '/rest/v1/schedules',
      queryParameters: {'id': 'in.($ids)'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete schedules');
    }
  }
}
