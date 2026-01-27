import 'package:dutytable/features/calendar/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateLastReadAtUseCase {
  final ChatRepository repository;
  UpdateLastReadAtUseCase(this.repository);

  Future<void> call(
    String userId,
    int calendarId,
    DateTime last_read_at,
  ) async {
    return await repository.updateLastReadAt(userId, calendarId, last_read_at);
  }
}
