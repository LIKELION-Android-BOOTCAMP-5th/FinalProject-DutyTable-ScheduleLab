import 'user_entity.dart';

class CalendarMemberEntity extends UserEntity {
  final int calendarId;
  final bool isAdmin;
  final DateTime? lastReadAt;

  CalendarMemberEntity({
    required super.id,
    required super.nickname,
    super.profileUrl,
    required this.calendarId,
    required this.isAdmin,
    this.lastReadAt,
  });
}
