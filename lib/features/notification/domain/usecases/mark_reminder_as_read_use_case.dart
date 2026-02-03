import 'package:injectable/injectable.dart';

import '../repositories/notification_repository.dart';

@injectable
class MarkReminderAsReadUseCase {
  final NotificationRepository repository;
  MarkReminderAsReadUseCase(this.repository);

  Future<void> call(int notificationId, String type) async {
    await repository.markReminderAsRead(notificationId, type);
  }
}
