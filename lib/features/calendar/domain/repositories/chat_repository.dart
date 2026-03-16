import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/detect_result.dart';
import '../entities/detected_schedule.dart';

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

  /// 메시지에서 일정 감지 (이전 메시지들과 함께 분석)
  Future<DetectResult?> detectSchedule(
    String message, {
    List<String> previousMessages = const [],
  });
}
