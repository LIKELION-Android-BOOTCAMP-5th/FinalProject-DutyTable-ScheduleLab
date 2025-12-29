class SupabaseUserModel {
  final String id;
  final String email;
  final String? profileURL;
  final String nickname;
  final bool is_google_calendar_connect;

  SupabaseUserModel({
    required this.id,
    required this.email,
    required this.profileURL,
    required this.nickname,
    required this.is_google_calendar_connect,
  });

  factory SupabaseUserModel.fromJson(Map<String, dynamic> json) {
    return SupabaseUserModel(
      id: json["id"] as String,
      email: json["email"] as String,
      profileURL: json["profileURL"] as String?,
      nickname: json["nickname"] as String,
      is_google_calendar_connect: json["is_google_calendar_connect"] as bool,
    );
  }
}
