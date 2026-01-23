import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchSchedulesUseCase {
  final ScheduleRepository repository;

  FetchSchedulesUseCase(this.repository);

  Future<List<ScheduleEntity>> call(int calendarId) {
    return repository.fetchSchedules(calendarId);
  }
}
