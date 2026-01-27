import 'package:dutytable/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteUserUseCase {
  final ProfileRepository repository;
  DeleteUserUseCase(this.repository);

  Future<void> call(String userId) async {
    await repository.deleteUser(userId);
  }
}
