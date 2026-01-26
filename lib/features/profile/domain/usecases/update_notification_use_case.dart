import 'package:dutytable/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNotificationUseCase {
  final ProfileRepository repository;
  UpdateNotificationUseCase(this.repository);

  Future<void> call(String userId, bool is_active_notification) async {
    await repository.updateNotification(userId, is_active_notification);
  }
}
