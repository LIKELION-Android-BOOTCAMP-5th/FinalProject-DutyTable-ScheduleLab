import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchSchedulesByRangeUseCase {
  final ScheduleRepository repository;

  FetchSchedulesByRangeUseCase(this.repository);

  Future<List<ScheduleEntity>> call(
    int calendarId,
    DateTime from,
    DateTime to,
  ) {
    return repository.fetchSchedulesByRange(
      calendarId: calendarId,
      from: from,
      to: to,
    );
  }
}
