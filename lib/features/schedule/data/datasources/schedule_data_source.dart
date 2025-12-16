import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/schedule_model.dart';

class ScheduleDataSource {
  static final ScheduleDataSource _shared = ScheduleDataSource();
  static ScheduleDataSource get shared => _shared;

  static const String _baseUrl = 'https://eexkppotdipyrzzjakur.supabase.co';

  static final String apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  // 인스턴스 초기화
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'apikey': apiKey, 'Content-Type': 'application/json'},
    ),
  );

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
