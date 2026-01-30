class SupabaseUserEntity {
  final String id;
  final String email;
  final String? profileUrl;
  final String nickname;
  final bool isGoogleCalendarConnect;

  SupabaseUserEntity({
    required this.id,
    required this.email,
    required this.profileUrl,
    required this.nickname,
    required this.isGoogleCalendarConnect,
  });
}
