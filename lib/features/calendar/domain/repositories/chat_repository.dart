abstract class ChatRepository {
  /// 공유 캘린더 목록 안 읽은 채팅 수 불러오기
  Future<int> readUnreadChatCount(int calendarId, String userId);
}
