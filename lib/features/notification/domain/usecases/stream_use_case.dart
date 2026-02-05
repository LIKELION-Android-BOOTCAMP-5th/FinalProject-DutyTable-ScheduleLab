import 'package:dutytable/features/notification/data/models/invite_notification_model.dart';
import 'package:dutytable/features/notification/data/models/reminder_notification_model.dart';
import 'package:injectable/injectable.dart';

import '../repositories/notification_repository.dart';

@injectable
class StreamUseCase {
  final NotificationRepository repository;

  StreamUseCase(this.repository);

  Stream<InviteNotificationModel> get inviteStream =>
      repository.inviteNotificationStream;

  Stream<ReminderNotificationModel> get reminderStream =>
      repository.reminderNotificationStream;
}
