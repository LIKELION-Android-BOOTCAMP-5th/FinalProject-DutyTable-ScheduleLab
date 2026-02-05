class ReminderNotificationEntity {
  final int id;
  final int calendarId;
  final int scheduleId;
  final String userId;
  final String firstMessage;
  bool isRead;
  final DateTime createdAt;

  ReminderNotificationEntity({
    required this.id,
    required this.calendarId,
    required this.scheduleId,
    required this.userId,
    required this.firstMessage,
    required this.isRead,
    required this.createdAt,
  });
}
