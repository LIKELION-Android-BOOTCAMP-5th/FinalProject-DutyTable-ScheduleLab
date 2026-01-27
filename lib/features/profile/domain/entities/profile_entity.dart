class ProfileEntity {
  final int id;
  final String nickname;
  final String email;
  final DateTime createdAt;
  final bool isGoogleCalendarConnect;
  final bool allowedNotification;
  final String? profileUrl;

  ProfileEntity({
    required this.id,
    required this.nickname,
    required this.email,
    required this.createdAt,
    required this.isGoogleCalendarConnect,
    required this.allowedNotification,
    this.profileUrl,
  });
}
