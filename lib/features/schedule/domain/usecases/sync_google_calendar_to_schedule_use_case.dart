import 'package:dutytable/features/schedule/domain/repositories/google_calendar_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SyncGoogleCalendarToScheduleUseCase {
  final GoogleCalendarRepository repository;

  SyncGoogleCalendarToScheduleUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call() {
    return repository.syncGoogleCalendarToSchedule();
  }
}
