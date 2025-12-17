class ReminderNotificationModel {
  final int id;
  final String calendarId;
  final int scheduleId;
  final String userId;
  final String firstMessage;
  final String secondMessage;
  final bool isRead;
  final DateTime createdAt;

  ReminderNotificationModel({
    required this.id,
    required this.calendarId,
    required this.scheduleId,
    required this.userId,
    required this.firstMessage,
    required this.secondMessage,
    required this.isRead,
    required this.createdAt,
  });

  factory ReminderNotificationModel.fromJson(Map<String, dynamic> json) {
    return ReminderNotificationModel(
      id: json['id'] as int,
      calendarId: json['calendar_id'].toString(),
      scheduleId: json['schedule_id'] as int,
      userId: json['user_id'] as String,
      firstMessage: json['first_message'] as String,
      secondMessage: json['second_message'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calendar_id': calendarId,
      'schedule_id': scheduleId,
      'user_id': userId,
      'first_message': firstMessage,
      'second_message': secondMessage,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ReminderNotificationModel(id: $id, calendarId: $calendarId, scheduleId: $scheduleId, userId: $userId, firstMessage: $firstMessage, secondMessage: $secondMessage, isRead: $isRead, createdAt: $createdAt)';
  }
}
