import 'package:injectable/injectable.dart';

import '../repositories/notification_repository.dart';

@injectable
class HasUnreadNotificationsUseCase {
  final NotificationRepository repository;
  HasUnreadNotificationsUseCase(this.repository);

  Future<List<dynamic>> call() async {
    return await repository.hasUnreadNotifications();
  }
}
