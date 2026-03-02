import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddScheduleUseCase {
  final ScheduleRepository repository;

  AddScheduleUseCase(this.repository);

  // [수정] 인자 타입을 List<Map>에서 단일 Map으로 변경
  Future<void> call(Map<String, dynamic> schedulePayload) {
    return repository.addSchedule(schedulePayload);
  }
}
