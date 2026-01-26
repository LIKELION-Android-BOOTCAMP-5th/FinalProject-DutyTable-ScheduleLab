import 'package:injectable/injectable.dart';

import '../repositories/profile_repository.dart';

@injectable
class NicknameOverlappingUseCase {
  final ProfileRepository repository;
  NicknameOverlappingUseCase(this.repository);

  Future<bool> call(String editingNickname) async {
    return await repository.nicknameOverlapping(editingNickname);
  }
}
