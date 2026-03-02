import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<void> addSchedule(Map<String, dynamic> payload);

  Future<List<ScheduleEntity>> fetchSchedules(int calendarId);
  Future<ScheduleEntity> fetchScheduleById(int scheduleId);
  Future<List<ScheduleEntity>> fetchMySchedules({DateTime? from, DateTime? to});
  Future<List<ScheduleEntity>> fetchAllSharedSchedules();
  Future<List<ScheduleEntity>> fetchSchedulesByRange({
    required int calendarId,
    required DateTime from,
    required DateTime to,
  });

  Future<void> updateSchedule({
    required int scheduleId,
    required Map<String, dynamic> payload,
  });
  Future<void> updateSchedulesByGroupId({
    required String repeatGroupId,
    required Map<String, dynamic> payload,
  });

  Future<void> deleteSchedules(int scheduleId);
  Future<void> deleteSchedulesByGroupId(String groupId);
  Future<void> deleteAllSchedules(Set<String> scheduleIds);
}
