import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateSchedulesByGroupIdUseCase {
  final ScheduleRepository repository;

  UpdateSchedulesByGroupIdUseCase(this.repository);

  Future<void> call(String repeatGroupId, Map<String, dynamic> payload) {
    return repository.updateSchedulesByGroupId(
      repeatGroupId: repeatGroupId,
      payload: payload,
    );
  }
}
