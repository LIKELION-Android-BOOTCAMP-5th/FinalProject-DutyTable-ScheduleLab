class ProfileModel {
  final int id;
  final String nickname;
  final String email;
  final DateTime createdAt;
  final bool isGoogleCalendarConnect;
  final bool allowedNotification;
  final String? profileUrl;

  ProfileModel({
    required this.id,
    required this.nickname,
    required this.email,
    required this.createdAt,
    required this.isGoogleCalendarConnect,
    required this.allowedNotification,
    this.profileUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"] as int,
      nickname: json["nickname"] as String,
      email: json["email"] as String,
      createdAt: DateTime.parse(json["created_at"] as String),
      isGoogleCalendarConnect: json["is_google_calendar_connect"] as bool,
      allowedNotification: json["allowed_notification"] as bool,
      profileUrl: json["profile_url"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'email': email,
      'createdAt': createdAt,
      'is_google_calendar_connect': isGoogleCalendarConnect,
      'allowed_notification': allowedNotification,
      'profile_url': profileUrl,
    };
  }
}
