class ChatModel {
  final int id;
  final int calendar_id;
  final String message;
  final String user_id;
  final DateTime created_at;

  ChatModel({
    required this.id,
    required this.calendar_id,
    required this.message,
    required this.user_id,
    required this.created_at,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["id"] as int,
      calendar_id: json["calendar_id"] as int,
      message: json["message"] as String,
      user_id: json["user_id"] as String,
      created_at: DateTime.parse(json["created_at"] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calendar_id': calendar_id,
      'message': message,
      'user_id': user_id,
      'created_at': created_at,
    };
  }
}
