import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchScheduleByIdUseCase {
  final ScheduleRepository repository;

  FetchScheduleByIdUseCase(this.repository);

  Future<ScheduleEntity> call(int scheduleId) {
    return repository.fetchScheduleById(scheduleId);
  }
}
