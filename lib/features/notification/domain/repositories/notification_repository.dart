import '../../data/models/invite_notification_model.dart';
import '../../data/models/reminder_notification_model.dart';

abstract class NotificationRepository {
  void setupRealtimeListeners();
  Stream<InviteNotificationModel> get inviteNotificationStream;
  Stream<ReminderNotificationModel> get reminderNotificationStream;
  Future<void> deleteAllNotifications();
  Future<List<dynamic>> hasUnreadNotifications();
  Future<void> markReminderAsRead(int notificationId, String type);
}
