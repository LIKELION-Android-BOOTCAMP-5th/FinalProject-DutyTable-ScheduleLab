import 'package:dutytable/features/calendar/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // ← RealtimeChannel import

@injectable
class SubscribeMessagesUseCase {
  final ChatRepository repository;

  SubscribeMessagesUseCase(this.repository);

  RealtimeChannel call(
    int calendarId,
    Function(Map<String, dynamic>) onMessage,
  ) {
    return repository.subscribeToMessages(calendarId, onMessage);
  }
}
