import 'package:dutytable/features/calendar/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchChatMessagesUseCase {
  final ChatRepository repository;
  FetchChatMessagesUseCase(this.repository);

  Future<List<Map<String, dynamic>>> call(int calendarId) async {
    return await repository.fetchChatMessages(calendarId);
  }
}
