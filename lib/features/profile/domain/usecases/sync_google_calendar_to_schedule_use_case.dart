import 'package:injectable/injectable.dart';

import '../../../schedule/domain/repositories/google_calendar_repository.dart';

@injectable
class SyncGoogleCalendarToScheduleUseCase {
  final GoogleCalendarRepository repository;
  SyncGoogleCalendarToScheduleUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.syncGoogleCalendarToSchedule();
  }
}
