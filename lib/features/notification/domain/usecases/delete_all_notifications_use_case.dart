import 'package:dutytable/features/notification/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAllNotificationsUseCase {
  final NotificationRepository repository;
  DeleteAllNotificationsUseCase(this.repository);

  Future<void> call() async {
    await repository.deleteAllNotifications();
  }
}
