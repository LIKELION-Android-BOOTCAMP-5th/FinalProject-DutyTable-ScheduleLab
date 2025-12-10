class ChatMessageModel {
  final int id;
  final int calendar_id;
  final String message;
  final String user_id;
  final DateTime created_at;

  ChatMessageModel({
    required this.id,
    required this.calendar_id,
    required this.message,
    required this.user_id,
    required this.created_at,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["id"] as int,
      calendar_id: json["calendar_id"] as int,
      message: ["message"] as String,
      user_id: json["user_id"] as String,
      created_at: DateTime.parse(json["created_at"] as String),
    );
  }
}
