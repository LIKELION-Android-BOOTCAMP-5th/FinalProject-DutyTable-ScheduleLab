import 'dart:io';

abstract class UserRepository {
  Future<bool> checkNicknameDuplication(String nickname);
  Future<String> uploadProfileImage(File imageFile);
  Future<void> completeSignup(Map<String, dynamic> updates);
}
