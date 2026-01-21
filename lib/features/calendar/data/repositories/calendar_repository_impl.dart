import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/domain/entities/calendar_entity.dart';
import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CalendarRepository)
class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarDataSource _dataSource;

  CalendarRepositoryImpl(this._dataSource);

  @override
  Future<int> createSharedCalendar({
    required String title,
    String? imageUrl,
    String? description,
    required List<String> invitedUserIds,
  }) async {
    return await _dataSource.createSharedCalendar(
      title: title,
      imageURL: imageUrl,
      description: description,
      invitedUserIds: invitedUserIds,
    );
  }

  @override
  Future<bool> updateCalendarInfo({
    String? title,
    String? description,
    String? imageUrl,
    required int calendarId,
  }) async {
    return await _dataSource.updateCalendarInfo(
      title: title,
      description: description,
      imageURL: imageUrl,
      calendarId: calendarId,
    );
  }

  @override
  Future<CalendarEntity> readPersonalCalendar() async {
    return await _dataSource.readPersonalCalendar();
  }

  @override
  Future<CalendarEntity> readSharedCalendarFromId(int calendarId) async {
    return await _dataSource.readSharedCalendarFromId(calendarId);
  }

  @override
  Future<String> readCalendarTitleById(int calendarId) async {
    return await _dataSource.readCalendarTitleById(calendarId);
  }

  @override
  Future<List<CalendarEntity>> readCalendarFinalList(String type) async {
    return await _dataSource.readCalendarFinalList(type);
  }

  @override
  Future<Map<String, dynamic>?> readNextSchedule(int calendarId) async {
    return await _dataSource.readNextSchedule(calendarId);
  }

  @override
  Future<void> deleteSharedCalendar(int calendarId) async {
    return await _dataSource.deleteCalendar(calendarId);
  }
}
