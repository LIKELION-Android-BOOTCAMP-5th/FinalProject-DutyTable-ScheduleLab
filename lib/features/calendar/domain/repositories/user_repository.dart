import 'package:dutytable/features/calendar/domain/entities/user_entity.dart';

abstract class UserRepository {
  /// 유저 초대
  Future<UserEntity?> findUserByNickname(String nickname);

  /// 방장 권한 넘김
  Future<void> transferAdminRole(int calendarId, String newAdminId);

  /// 멤버 추방
  Future<void> exileMember(int calendarId, String userId);

  /// 캘린더 나가기
  Future<void> outCalendar(int calendarId);

  /// 캘린더 나가기(복수)
  Future<void> outCalendars(List<int> calendarIds);

  /// 멤버 초대
  Future<void> inviteUsers(int calendarId, List<String> invitedUserIds);

  /// 구글 캘린더 연동 상태 가져오기
  Future<bool> readIsGoogleCalendarConnection();
}
