import 'package:dutytable/features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model_mapper.dart';
import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource dataSource;

  ScheduleRepositoryImpl(this.dataSource);

  @override
  Future<void> addSchedule(List<Map<String, dynamic>> payloads) {
    return dataSource.addSchedule(payloads);
  }

  @override
  Future<List<ScheduleEntity>> fetchSchedules(int calendarId) async {
    final models = await dataSource.fetchSchedules(calendarId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ScheduleEntity> fetchScheduleById(int scheduleId) async {
    final models = await dataSource.fetchScheduleById(scheduleId);
    return models.toEntity();
  }

  @override
  Future<List<ScheduleEntity>> fetchMySchedules({
    DateTime? from,
    DateTime? to,
  }) async {
    final models = await dataSource.fetchMySchedules(from: from, to: to);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ScheduleEntity>> fetchSchedulesByRange({
    required int calendarId,
    required DateTime from,
    required DateTime to,
  }) async {
    final models = await dataSource.fetchSchedulesByRange(
      calendarId: calendarId,
      from: from,
      to: to,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ScheduleEntity>> fetchAllSharedSchedules() async {
    final models = await dataSource.fetchAllSharedSchedules();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateSchedule({
    required int scheduleId,
    required Map<String, dynamic> payload,
  }) {
    return dataSource.updateSchedule(scheduleId: scheduleId, payload: payload);
  }

  @override
  Future<void> updateSchedulesByGroupId({
    required String repeatGroupId,
    required Map<String, dynamic> payload,
  }) {
    return dataSource.updateSchedulesByGroupId(
      repeatGroupId: repeatGroupId,
      payload: payload,
    );
  }

  @override
  Future<void> deleteSchedules(int scheduleId) {
    return dataSource.deleteSchedules(scheduleId);
  }

  @override
  Future<void> deleteSchedulesByGroupId(String groupId) {
    return dataSource.deleteSchedulesByGroupId(groupId);
  }

  @override
  Future<void> deleteAllSchedules(Set<String> ids) {
    return dataSource.deleteAllSchedules(ids);
  }
}
