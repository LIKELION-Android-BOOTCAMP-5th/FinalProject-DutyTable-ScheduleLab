import 'package:dutytable/features/calendar/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadUnreadChatCountUseCase {
  final ChatRepository _repository;

  ReadUnreadChatCountUseCase(this._repository);

  Future<int> call(int calendarId, String userId) {
    return _repository.readUnreadChatCount(calendarId, userId);
  }
}
