import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddScheduleUseCase {
  final ScheduleRepository repository;

  AddScheduleUseCase(this.repository);

  Future<void> call(List<Map<String, dynamic>> schedule) {
    return repository.addSchedule(schedule);
  }
}
