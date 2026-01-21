import 'dart:io';

abstract class StorageRepository {
  /// 공유, 개인 캘린더 이미지 추가
  Future<String> uploadCalendarImage(File imageFile, int calendarId);

  /// 공유, 개인 캘린더 이미지 삭제
  Future<void> deleteCalendarImage(String? imageUrl);
}
