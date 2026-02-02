import 'package:dutytable/features/auth/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteSignupUseCase {
  final UserRepository repository;
  CompleteSignupUseCase(this.repository);

  Future<void> call(Map<String, dynamic> updates) async {
    await repository.completeSignup(updates);
  }
}
