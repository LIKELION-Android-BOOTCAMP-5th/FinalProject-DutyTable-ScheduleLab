class ChatEntity {
  final int id;
  final int calendar_id;
  final String message;
  final DateTime user_id;
  final bool created_at;

  ChatEntity({
    required this.id,
    required this.calendar_id,
    required this.message,
    required this.user_id,
    required this.created_at,
  });
}
