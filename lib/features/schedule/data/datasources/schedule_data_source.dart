import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:dutytable/main.dart';

import '../models/schedule_model.dart';

class ScheduleDataSource {
  ScheduleDataSource._();
  static final ScheduleDataSource instance = ScheduleDataSource._();

  final Dio _dio = DioClient.shared.dio;

  /// CREATE
  Future<void> addSchedule(Map<String, dynamic> payload) async {
    try {
      await _dio.post(
        '/rest/v1/schedules',
        data: payload,
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
      final res = await _dio.patch(
        '/rest/v1/schedules',
        queryParameters: {'id': 'eq.$scheduleId'},
        data: payload,
        options: Options(
          headers: {
            'Prefer': 'return=minimal', // 응답 데이터 필요 없을 때
          },
        ),
      );

      // status 204가 정상
      if (res.statusCode != 204) {
        throw Exception('Failed to update schedule');
      }
    } catch (e) {
      throw Exception("update 에러: $e");
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
