class CalendarMemberModel {
  final int calendar_id;
  final String user_id;
  final bool is_admin;
  final DateTime? last_read_at;
  final String nickname;
  final String? profileUrl;

  CalendarMemberModel({
    required this.calendar_id,
    required this.user_id,
    required this.is_admin,
    required this.last_read_at,
    required this.nickname,
    required this.profileUrl,
  });

  factory CalendarMemberModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? userJson =
        json['users'] as Map<String, dynamic>?;

    final String memberNickname = userJson?['nickname'] as String? ?? 'Unknown';

    final String? profileUrl = userJson?['profileurl'] as String?;
    return CalendarMemberModel(
      calendar_id: json["calendar_id"] as int,
      user_id: json["user_id"] as String,
      is_admin: json["is_admin"] as bool,
      last_read_at: DateTime.parse(json["last_read_at"] as String),
      nickname: memberNickname,
      profileUrl: profileUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calendar_id': calendar_id,
      'user_id': user_id,
      'is_admin': is_admin,
      'last_read_at': last_read_at,
      'nickname': nickname,
      'profileUrl': profileUrl,
    };
  }

  CalendarMemberModel copyWith({
    int? calendar_id,
    String? user_id,
    bool? is_admin,
    DateTime? last_read_at,
    String? nickname,
    String? profileUrl,
  }) {
    return CalendarMemberModel(
      calendar_id: calendar_id ?? this.calendar_id,
      user_id: user_id ?? this.user_id,
      is_admin: is_admin ?? this.is_admin,
      last_read_at: last_read_at ?? this.last_read_at,
      nickname: nickname ?? this.nickname,
      profileUrl: profileUrl,
    );
  }
}
