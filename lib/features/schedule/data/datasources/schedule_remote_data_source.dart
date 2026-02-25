import 'package:dutytable/features/schedule/data/models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  /// CREATE
  Future<void> addSchedule(Map<String, dynamic> payload);

  /// READ
  Future<List<ScheduleModel>> fetchSchedules(int calendarId);
  Future<ScheduleModel> fetchScheduleById(int scheduleId);
  Future<List<ScheduleModel>> fetchMySchedules({DateTime? from, DateTime? to});
  Future<List<ScheduleModel>> fetchAllSharedSchedules();
  Future<List<ScheduleModel>> fetchSchedulesByRange({
    required int calendarId,
    required DateTime from,
    required DateTime to,
  });

  /// UPDATE
  Future<void> updateSchedule({
    required int scheduleId,
    required Map<String, dynamic> payload,
  });
  Future<void> updateSchedulesByGroupId({
    required String repeatGroupId,
    required Map<String, dynamic> payload,
  });

  /// DELETE
  Future<void> deleteSchedules(int scheduleId);
  Future<void> deleteSchedulesByGroupId(String groupId);
  Future<void> deleteAllSchedules(Set<String> scheduleIds);
}
