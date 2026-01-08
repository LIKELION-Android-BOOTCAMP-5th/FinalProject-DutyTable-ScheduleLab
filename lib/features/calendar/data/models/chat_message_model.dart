class ChatMessageModel {
  final int id;
  final int calendarId;
  final String message;
  final String userId;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.calendarId,
    required this.message,
    required this.userId,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"] as int,
      calendarId: json["calendar_id"] as int,
      message: ["message"] as String,
      userId: json["user_id"] as String,
      createdAt: DateTime.parse(json["created_at"] as String),
    );
  }
}
