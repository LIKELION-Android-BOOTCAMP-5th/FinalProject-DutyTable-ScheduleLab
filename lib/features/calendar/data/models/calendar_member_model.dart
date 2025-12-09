class CalendarMemberModel {
  final int calendar_id;
  final String user_id;
  final bool is_admin;
  final DateTime last_read_at;
  final String nickname;

  CalendarMemberModel({
    required this.calendar_id,
    required this.user_id,
    required this.is_admin,
    required this.last_read_at,
    required this.nickname,
  });

  factory CalendarMemberModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? userJson =
        json['users'] as Map<String, dynamic>?;
    final String memberNickname = userJson?['nickname'] as String? ?? 'Unknown';
    return CalendarMemberModel(
      calendar_id: json["calendar_id"] as int,
      user_id: json["user_id"] as String,
      is_admin: json["is_admin"] as bool,
      last_read_at: DateTime.parse(json["last_read_at"] as String),
      nickname: memberNickname,
    );
  }
}
