import 'package:dutytable/features/calendar/data/datasources/chat_data_source.dart';
import 'package:dutytable/features/calendar/domain/entities/detect_result.dart';
import 'package:dutytable/features/calendar/domain/entities/detected_schedule.dart';
import 'package:dutytable/features/calendar/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:realtime_client/src/realtime_channel.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Future<int> readUnreadChatCount(int calendarId, String userId) {
    return dataSource.readUnreadChatCount(calendarId, userId);
  }

  @override
  Future<void> chatInsert(String chatMessage, int calendarId) {
    return dataSource.chatInsert(chatMessage, calendarId);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchChatMessages(int calendarId) {
    return dataSource.fetchChatMessages(calendarId);
  }

  @override
  Future<void> updateLastReadAt(
    String userId,
    int calendarId,
    DateTime last_read_at,
  ) {
    return dataSource.updateLastReadAt(
      userId: userId,
      calendarId: calendarId,
      payload: {'last_read_at': DateTime.now().toUtc().toIso8601String()},
    );
  }

  @override
  RealtimeChannel subscribeToMessages(
    int calendarId,
    Function(Map<String, dynamic>) onMessage,
  ) {
    return dataSource.subscribeToMessages(calendarId, onMessage);
  }

  @override
  Future<Map<String, dynamic>> fetchUserInfo(String senderId) {
    return dataSource.fetchNewChatImageNickname(senderId);
  }

  @override
  Future<DetectResult?> detectSchedule(
    String message, {
    List<String> previousMessages = const [],
  }) =>
      dataSource.detectSchedule(message, previousMessages: previousMessages);
}
