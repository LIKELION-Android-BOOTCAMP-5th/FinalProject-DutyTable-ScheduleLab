import 'package:dutytable/features/auth/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckNicknameDuplication {
  final UserRepository repository;
  CheckNicknameDuplication(this.repository);

  Future<bool> call(String nickname) async {
    return await repository.checkNicknameDuplication(nickname);
  }
}
