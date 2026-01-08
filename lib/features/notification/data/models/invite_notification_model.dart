class InviteNotificationModel {
  final int id;
  final String userId;
  final int calendarId;
  final String calendarName;
  final String from;
  final String message;
  bool isRead;
  final DateTime createdAt;
  final bool is_accepted;

  InviteNotificationModel(
      {required this.id,
        required this.userId,
        required this.calendarId,
        required this.calendarName,
        required this.from,
        required this.message,
        required this.isRead,
        required this.createdAt,
        this.is_accepted = false});

  factory InviteNotificationModel.fromJson(Map<String, dynamic> json) {
    return InviteNotificationModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] as String? ?? '',
      calendarId: json['calendar_id'] is int
          ? json['calendar_id']
          : int.parse(json['calendar_id'].toString()),
      calendarName: json['calendar_name'] as String? ?? '',
      from: json['from'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] is bool
          ? json['is_read']
          : (json['is_read'] as String? ?? 'false') == 'true',
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      is_accepted: json['is_accepted'] is bool
          ? json['is_accepted']
          : (json['is_accepted'] as String? ?? 'false') == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'calendar_id': calendarId,
      'calendar_name': calendarName,
      'from': from,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'is_accepted': is_accepted,
    };
  }

  @override
  String toString() {
    return 'InviteNotificationModel(id: $id, userId: $userId, calendarId: $calendarId, calendarName: $calendarName, from: $from, message: $message, isRead: $isRead, createdAt: $createdAt, is_accepted: $is_accepted)';
  }
}
