import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatRepository {
  /// 공유 캘린더 목록 안 읽은 채팅 수 불러오기
  Future<int> readUnreadChatCount(int calendarId, String userId);
  Future<void> chatInsert(String chatMessage, int calendarId);
  Future<List<Map<String, dynamic>>> fetchChatMessages(int calendarId);
  Future<void> updateLastReadAt(
    String userId,
    int calendarId,
    DateTime last_read_at,
  );
  RealtimeChannel subscribeToMessages(
    int calendarId,
    Function(Map<String, dynamic>) onMessage,
  );
  Future<Map<String, dynamic>> fetchUserInfo(String senderId);
}
