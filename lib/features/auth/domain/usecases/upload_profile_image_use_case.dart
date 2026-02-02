import 'dart:io';

import 'package:dutytable/features/auth/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadProfileImageUseCase {
  final UserRepository repository;
  UploadProfileImageUseCase(this.repository);

  Future<String> call(File imageFile) async {
    return await repository.uploadProfileImage(imageFile);
  }
}
