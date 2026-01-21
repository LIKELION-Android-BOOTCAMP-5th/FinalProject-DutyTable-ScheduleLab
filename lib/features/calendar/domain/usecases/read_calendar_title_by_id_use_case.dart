import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadCalendarTitleByIdUseCase {
  final CalendarRepository _repository;

  ReadCalendarTitleByIdUseCase(this._repository);

  Future<String> call(int calendarId) {
    return _repository.readCalendarTitleById(calendarId);
  }
}
