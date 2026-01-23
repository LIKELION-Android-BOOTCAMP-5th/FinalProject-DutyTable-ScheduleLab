import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateScheduleUseCase {
  final ScheduleRepository repository;

  UpdateScheduleUseCase(this.repository);

  Future<void> call(int scheduleId, Map<String, dynamic> payload) {
    return repository.updateSchedule(scheduleId: scheduleId, payload: payload);
  }
}
