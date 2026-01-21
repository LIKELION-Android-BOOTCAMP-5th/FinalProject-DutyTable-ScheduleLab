import 'package:dutytable/features/calendar/domain/entities/calendar_entity.dart';
import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadSharedCalendarFromIdUseCase {
  final CalendarRepository _repository;

  ReadSharedCalendarFromIdUseCase(this._repository);

  Future<CalendarEntity> call(int calendarId) {
    return _repository.readSharedCalendarFromId(calendarId);
  }
}
