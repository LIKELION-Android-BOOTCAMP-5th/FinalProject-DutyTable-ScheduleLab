import '../../domain/entities/calendar_member_entity.dart';

class CalendarMemberModel extends CalendarMemberEntity {
  CalendarMemberModel({
    required super.calendarId,
    required super.id,
    required super.isAdmin,
    super.lastReadAt,
    required super.nickname,
    super.profileUrl,
  });

  factory CalendarMemberModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? userJson =
        json['users'] as Map<String, dynamic>?;
    final String memberNickname = userJson?['nickname'] as String? ?? 'Unknown';
    final String? profileUrl = userJson?['profile_url'] as String?;

    return CalendarMemberModel(
      calendarId: json["calendar_id"] as int,
      id: json["user_id"] as String,
      isAdmin: json["is_admin"] as bool? ?? false,
      lastReadAt: json["last_read_at"] != null
          ? DateTime.parse(json["last_read_at"] as String)
          : null,
      nickname: memberNickname,
      profileUrl: profileUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calendar_id': calendarId,
      'user_id': id,
      'is_admin': isAdmin,
      'last_read_at': lastReadAt,
      'nickname': nickname,
      'profileUrl': profileUrl,
    };
  }
}
