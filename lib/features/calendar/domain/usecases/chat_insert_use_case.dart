import 'package:dutytable/features/calendar/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatInsertUseCase {
  final ChatRepository repository;
  ChatInsertUseCase(this.repository);

  Future<void> call(String chatMessage, int calendarId) async {
    return await repository.chatInsert(chatMessage, calendarId);
  }
}
