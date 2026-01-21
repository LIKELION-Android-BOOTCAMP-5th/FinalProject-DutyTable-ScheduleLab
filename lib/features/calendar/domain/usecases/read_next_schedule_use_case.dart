import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadNextScheduleUseCase {
  final CalendarRepository _repository;

  ReadNextScheduleUseCase(this._repository);

  Future<Map<String, dynamic>?> call(int calendarId) {
    return _repository.readNextSchedule(calendarId);
  }
}
