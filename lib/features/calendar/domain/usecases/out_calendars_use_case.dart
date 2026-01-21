import 'package:dutytable/features/calendar/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OutCalendarsUseCase {
  final UserRepository _repository;

  OutCalendarsUseCase(this._repository);

  Future<void> call(List<int> calendarIds) async {
    return await _repository.outCalendars(calendarIds);
  }
}
