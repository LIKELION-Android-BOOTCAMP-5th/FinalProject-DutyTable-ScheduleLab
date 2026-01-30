import 'dart:io';

import 'package:dutytable/features/auth/data/datasources/user_data_source.dart';
import 'package:dutytable/features/auth/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../main.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<bool> checkNicknameDuplication(String nickname) {
    return dataSource.isNicknameDuplicated(nickname);
  }

  @override
  Future<void> completeSignup(Map<String, dynamic> updates) {
    return dataSource.upsertUserProfile(updates);
  }

  @override
  Future<String> uploadProfileImage(File imageFile) {
    final userId = supabase.auth.currentUser!.id;
    return dataSource.uploadProfileImage(userId: userId, imageFile: imageFile);
  }
}
