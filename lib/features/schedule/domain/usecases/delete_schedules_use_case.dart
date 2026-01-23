import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteSchedulesUseCase {
  final ScheduleRepository repository;

  DeleteSchedulesUseCase(this.repository);

  Future<void> call(int scheduleId) {
    return repository.deleteSchedules(scheduleId);
  }
}
