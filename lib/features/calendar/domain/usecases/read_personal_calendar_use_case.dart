import 'package:dutytable/features/calendar/domain/entities/calendar_entity.dart';
import 'package:dutytable/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadPersonalCalendarUseCase {
  final CalendarRepository _repository;

  ReadPersonalCalendarUseCase(this._repository);

  Future<CalendarEntity> call() {
    return _repository.readPersonalCalendar();
  }
}
