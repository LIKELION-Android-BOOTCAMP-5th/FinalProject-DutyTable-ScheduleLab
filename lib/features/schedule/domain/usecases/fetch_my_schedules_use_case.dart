import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchMySchedulesUseCase {
  final ScheduleRepository repository;

  FetchMySchedulesUseCase(this.repository);

  Future<List<ScheduleEntity>> call() {
    return repository.fetchMySchedules();
  }
}
