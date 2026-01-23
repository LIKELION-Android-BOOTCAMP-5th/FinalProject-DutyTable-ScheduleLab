import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'schedule_remote_data_source.dart';
import '../models/schedule_model.dart';
import '../../../../main.dart';

@LazySingleton(as: ScheduleRemoteDataSource)
class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio _dio;

  ScheduleRemoteDataSourceImpl(this._dio);

  // ------------------ CREATE ------------------
  /// 일정 추가
  @override
  Future<void> addSchedule(List<Map<String, dynamic>> payloads) async {
    await _dio.post(
      '/rest/v1/schedules',
      data: payloads,
      options: Options(headers: {'Prefer': 'return=minimal'}),
    );
  }

  // ------------------ READ --------------------
  /// 스케줄 조회
  @override
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

  /// 스케줄 단건 조회
  @override
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

  /// 내 일정 불러오기
  @override
  Future<List<ScheduleModel>> fetchMySchedules({
    DateTime? from,
    DateTime? to,
  }) async {
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

    // 기간 파라미터가 있으면 범위 쿼리, 없으면 전체 쿼리 실행(위젯을 위해 확장성 있게 변경함)
    if (from != null && to != null) {
      return fetchSchedulesByRange(
        calendarId: myCalendarId,
        from: from,
        to: to,
      );
    } else {
      return fetchSchedules(myCalendarId);
    }
  }

  /// 모든 일정 불러오기
  @override
  Future<List<ScheduleModel>> fetchAllSharedSchedules() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) return [];

      // 1. 내가 멤버로 등록된 캘린더 ID들을 가져옴
      final memberResponse = await _dio.get(
        '/rest/v1/calendar_members',
        queryParameters: {
          'select': 'calendar_id',
          'user_id': 'eq.$currentUserId',
        },
      );

      final List<dynamic> memberData = memberResponse.data;
      if (memberData.isEmpty) return [];

      final List<int> calendarIds = memberData
          .map((item) => item['calendar_id'] as int)
          .toList();

      // 2. 해당 ID들에 속한 모든 일정 로드
      final idsQuery = "(${calendarIds.join(',')})";
      final scheduleResponse = await _dio.get(
        '/rest/v1/schedules',
        queryParameters: {'select': '*', 'calendar_id': 'in.$idsQuery'},
      );

      if (scheduleResponse.statusCode == 200) {
        final List<dynamic> jsonList = scheduleResponse.data;
        return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ fetchJoinedSharedSchedules 에러: $e");
      return [];
    }
  }

  @override
  Future<List<ScheduleModel>> fetchSchedulesByRange({
    required int calendarId,
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {
        'select': '*',
        'calendar_id': 'eq.$calendarId',
        'started_at': 'lte.${to.toIso8601String()}',
        'ended_at': 'gte.${from.toIso8601String()}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load schedules by range");
    }
  }

  // ------------------ UPDATE --------------------
  /// 일정 수정
  @override
  Future<void> updateSchedule({
    required int scheduleId,
    required Map<String, dynamic> payload,
  }) async {
    await _dio.patch(
      '/rest/v1/schedules',
      queryParameters: {'id': 'eq.$scheduleId'},
      data: payload,
    );
  }

  /// 일정 반복 수정
  @override
  Future<void> updateSchedulesByGroupId({
    required String repeatGroupId,
    required Map<String, dynamic> payload,
  }) async {
    await _dio.patch(
      '/rest/v1/schedules',
      queryParameters: {'repeat_group_id': 'eq.$repeatGroupId'},
      data: payload,
    );
  }

  // ------------------ DELETE --------------------
  /// 일정 삭제
  @override
  Future<void> deleteSchedules(int scheduleId) async {
    await _dio.delete(
      '/rest/v1/schedules',
      queryParameters: {'id': 'eq.$scheduleId'},
    );
  }

  /// 일정 반복 삭제
  @override
  Future<void> deleteSchedulesByGroupId(String groupId) async {
    await _dio.delete(
      '/rest/v1/schedules',
      queryParameters: {'repeat_group_id': 'eq.$groupId'},
    );
  }

  /// 모든 일정 삭제
  @override
  Future<void> deleteAllSchedules(Set<String> scheduleIds) async {
    if (scheduleIds.isEmpty) return;

    await _dio.delete(
      '/rest/v1/schedules',
      queryParameters: {'id': 'in.(${scheduleIds.join(',')})'},
    );
  }
}
