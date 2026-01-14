class SupabaseUserModel {
  final String id;
  final String email;
  final String? profileUrl;
  final String nickname;
  final bool isGoogleCalendarConnect;

  SupabaseUserModel({
    required this.id,
    required this.email,
    required this.profileUrl,
    required this.nickname,
    required this.isGoogleCalendarConnect,
  });

  factory SupabaseUserModel.fromJson(Map<String, dynamic> json) {
    return SupabaseUserModel(
      id: json["id"] as String,
      email: json["email"] as String,
      profileUrl: json["profile_url"] as String?,
      nickname: json["nickname"] as String,
      isGoogleCalendarConnect: json["is_google_calendar_connect"] as bool,
    );
  }
}
