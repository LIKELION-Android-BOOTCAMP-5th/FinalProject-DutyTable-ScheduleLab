import 'package:dutytable/features/profile/data/datasources/profile_data_source.dart';
import 'package:dutytable/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);
  @override
  Future<void> deleteUser(String userId) {
    return dataSource.deleteUser(userId);
  }

  @override
  Future<Map<String, dynamic>> fetchUser() {
    return dataSource.fetchUser();
  }

  @override
  Future<void> updateGoogleSync(String userId, bool syncStatus) {
    return dataSource.updateUserProfile(
      userId: userId,
      payload: {'is_google_calendar_connect': syncStatus},
    );
  }

  @override
  Future<void> updateImage(String userId, String? publicUrl) {
    return dataSource.updateUserProfile(
      userId: userId,
      payload: {'profile_url': publicUrl},
    );
  }

  @override
  Future<void> updateNickname(String userId, String nickname) {
    return dataSource.updateUserProfile(
      userId: userId,
      payload: {'nickname': nickname},
    );
  }

  @override
  Future<bool> nicknameOverlapping(String editingNickname) {
    return dataSource.nicknameOverlapping(editingNickname);
  }

  @override
  Future<void> updateNotification(String userId, bool is_active_notification) {
    return dataSource.updateUserProfile(
      userId: userId,
      payload: {'allowed_notification': is_active_notification},
    );
  }
}
