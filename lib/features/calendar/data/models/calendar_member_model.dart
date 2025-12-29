class CalendarMemberModel {
  final int calendarId;
  final String userId;
  final bool isAdmin;
  final DateTime? lastReadAt;
  final String nickname;
  final String? profileUrl;

  CalendarMemberModel({
    required this.calendarId,
    required this.userId,
    required this.isAdmin,
    required this.lastReadAt,
    required this.nickname,
    required this.profileUrl,
  });

  factory CalendarMemberModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? userJson =
        json['users'] as Map<String, dynamic>?;

    final String memberNickname = userJson?['nickname'] as String? ?? 'Unknown';

    final String? profileUrl = userJson?['profileurl'] as String?;
    return CalendarMemberModel(
      calendarId: json["calendar_id"] as int,
      userId: json["user_id"] as String,
      isAdmin: json["is_admin"] as bool,
      lastReadAt: DateTime.parse(json["last_read_at"] as String),
      nickname: memberNickname,
      profileUrl: profileUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calendar_id': calendarId,
      'user_id': userId,
      'is_admin': isAdmin,
      'last_read_at': lastReadAt,
      'nickname': nickname,
      'profileUrl': profileUrl,
    };
  }

  CalendarMemberModel copyWith({
    int? calendarId,
    String? userId,
    bool? isAdmin,
    DateTime? lastReadAt,
    String? nickname,
    String? profileUrl,
  }) {
    return CalendarMemberModel(
      calendarId: calendarId ?? this.calendarId,
      userId: userId ?? this.userId,
      isAdmin: isAdmin ?? this.isAdmin,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl,
    );
  }
}
