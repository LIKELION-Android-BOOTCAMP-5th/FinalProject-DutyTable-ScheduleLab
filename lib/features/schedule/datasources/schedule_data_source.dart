import 'package:dio/dio.dart';
import 'package:dutytable/features/schedule/models/schedule_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  Future<List<ScheduleModel>> fetchSchedules(int scheduleId) async {
    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {'select': '*', 'calendar_id': 'eq.$scheduleId'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load schedules");
    }
  }
}
