import 'package:dutytable/features/calendar/domain/entities/calendar_entity.dart';
import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadCalendarFinalListUseCase {
  final CalendarRepository _repository;

  ReadCalendarFinalListUseCase(this._repository);

  Future<List<CalendarEntity>> call(String type) {
    return _repository.readCalendarFinalList(type);
  }
}
