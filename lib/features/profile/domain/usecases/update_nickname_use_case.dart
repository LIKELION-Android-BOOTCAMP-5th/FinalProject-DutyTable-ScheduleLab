import 'package:dutytable/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateNicknameUseCase {
  final ProfileRepository repository;
  UpdateNicknameUseCase(this.repository);

  Future<void> call(String userId, String nickname) async {
    await repository.updateNickname(userId, nickname);
  }
}
