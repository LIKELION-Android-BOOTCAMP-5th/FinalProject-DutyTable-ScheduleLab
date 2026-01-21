import '../entities/calendar_entity.dart';

abstract class CalendarRepository {
  // CREATE
  /// 공유 캘린더 생성
  Future<int> createSharedCalendar({
    required String title,
    String? imageUrl,
    String? description,
    required List<String> invitedUserIds,
  });

  // READ
  /// 공유 캘린더 목록 불러오기
  Future<List<CalendarEntity>> readCalendarFinalList(String type);

  /// 공유 캘린더 불러오기
  Future<CalendarEntity> readSharedCalendarFromId(int calendarId);

  /// 개인 캘린더 불러오기
  Future<CalendarEntity> readPersonalCalendar();

  /// 공유 캘린더 제목 불러오기
  Future<String> readCalendarTitleById(int calendarId);

  /// 공유 캘린더 다음 일정 불러오기
  Future<Map<String, dynamic>?> readNextSchedule(int calendarId);

  // UPDATE
  /// 공유, 개인 캘린더 정보 업데이트
  Future<bool> updateCalendarInfo({
    String? title,
    String? description,
    String? imageUrl,
    required int calendarId,
  });

  // DELETE
  /// 공유 캘린더 삭제
  Future<void> deleteSharedCalendar(int calendarId);
}
