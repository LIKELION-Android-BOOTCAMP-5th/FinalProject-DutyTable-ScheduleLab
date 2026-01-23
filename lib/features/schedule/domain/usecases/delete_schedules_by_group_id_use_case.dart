import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteSchedulesByGroupIdUseCase {
  final ScheduleRepository repository;

  DeleteSchedulesByGroupIdUseCase(this.repository);

  Future<void> call(String groupId) {
    return repository.deleteSchedulesByGroupId(groupId);
  }
}
