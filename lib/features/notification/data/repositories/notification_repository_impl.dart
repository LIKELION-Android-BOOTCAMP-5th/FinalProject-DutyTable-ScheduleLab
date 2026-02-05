import 'package:injectable/injectable.dart';

import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_data_source.dart';
import '../models/invite_notification_model.dart';
import '../models/reminder_notification_model.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl(this.dataSource);

  @override
  Future<void> deleteAllNotifications() async {
    await dataSource.deleteAllNotifications();
  }

  @override
  Future<List<dynamic>> hasUnreadNotifications() async {
    final inviteFuture = dataSource.getInviteNotifications();
    final reminderFuture = dataSource.getReminderNotifications();
    final result = await Future.wait([inviteFuture, reminderFuture]);
    return [...result[0], ...result[1]];
  }

  @override
  Future<void> markReminderAsRead(int notificationId, String type) async {
    await dataSource.markAsRead(notificationId, type);
  }

  @override
  void setupRealtimeListeners() {
    dataSource.startRealtimeListeners();
  }

  @override
  Stream<InviteNotificationModel> get inviteNotificationStream =>
      dataSource.newInviteNotifications;

  @override
  Stream<ReminderNotificationModel> get reminderNotificationStream =>
      dataSource.newReminderNotifications;
}
