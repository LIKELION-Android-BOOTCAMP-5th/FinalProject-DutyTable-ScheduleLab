class InviteNotificationModel {
  final int id;
  final String userId;
  final int calendarId;
  final String message;
  bool isRead;
  final DateTime createdAt;
  final bool is_accepted;

  InviteNotificationModel({
    required this.id,
    required this.userId,
    required this.calendarId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.is_accepted = false,
  });

  factory InviteNotificationModel.fromJson(Map<String, dynamic> json) {
    return InviteNotificationModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      calendarId: int.parse(json['calendar_id'].toString()),
      message: json['message'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      is_accepted: json['is_accepted'] ?? false,
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
      'is_accepted': is_accepted,
    };
  }

  @override
  String toString() {
    return 'InviteNotificationModel(id: $id, userId: $userId, calendarId: $calendarId, message: $message, isRead: $isRead, createdAt: $createdAt, is_accepted: $is_accepted)';
  }
}
