import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteCalendarUseCase {
  final CalendarRepository _repository;

  DeleteCalendarUseCase(this._repository);

  Future<void> call(int calendarId) {
    return _repository.deleteSharedCalendar(calendarId);
  }
}
