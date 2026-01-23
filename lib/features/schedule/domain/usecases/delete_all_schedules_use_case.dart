import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAllSchedulesUseCase {
  final ScheduleRepository repository;

  DeleteAllSchedulesUseCase(this.repository);

  Future<void> call(Set<String> scheduleIds) {
    return repository.deleteAllSchedules(scheduleIds);
  }
}
