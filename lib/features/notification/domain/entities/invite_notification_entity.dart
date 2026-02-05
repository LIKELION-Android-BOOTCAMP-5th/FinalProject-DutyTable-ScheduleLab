class InviteNotificationEntity {
  final int id;
  final String userId;
  final int calendarId;
  final String calendarName;
  final String from;
  final String message;
  bool isRead;
  final DateTime createdAt;
  final bool isAccepted;

  InviteNotificationEntity({
    required this.id,
    required this.userId,
    required this.calendarId,
    required this.calendarName,
    required this.from,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.isAccepted,
  });
}
