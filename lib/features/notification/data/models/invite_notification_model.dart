class InviteNotificationModel {
  final int id;
  final String userId;
  final int calendarId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  InviteNotificationModel({
    required this.id,
    required this.userId,
    required this.calendarId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory InviteNotificationModel.fromJson(Map<String, dynamic> json) {
    return InviteNotificationModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      calendarId: int.parse(json['calendar_id'].toString()),
      message: json['message'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'calendar_id': calendarId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'InviteNotificationModel(id: $id, userId: $userId, calendarId: $calendarId, message: $message, isRead: $isRead, createdAt: $createdAt)';
  }
}
