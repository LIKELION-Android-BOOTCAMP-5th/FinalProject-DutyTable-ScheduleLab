import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OutCalendarUseCase {
  final UserRepository _repository;

  OutCalendarUseCase(this._repository);

  Future<void> call(int calendarId) async {
    return _repository.outCalendar(calendarId);
  }
}
