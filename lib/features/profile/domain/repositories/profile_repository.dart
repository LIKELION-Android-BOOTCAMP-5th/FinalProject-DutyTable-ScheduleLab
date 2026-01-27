abstract class ProfileRepository {
  Future<void> updateNickname(String userId, String nickname);
  Future<Map<String, dynamic>> fetchUser();
  Future<void> updateGoogleSync(String userId, bool syncStatus);
  Future<void> updateNotification(String userId, bool is_active_notification);
  Future<void> updateImage(String userId, String? publicUrl);
  Future<bool> nicknameOverlapping(String editingNickname);
  Future<void> deleteUser(String userId);
}
