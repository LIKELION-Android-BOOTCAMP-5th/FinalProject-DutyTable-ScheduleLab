import 'package:dutytable/features/auth/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginInitUseCase {
  final LoginRepository repository;
  LoginInitUseCase(this.repository);

  Future<bool> call() async {
    return await repository.checkOnboardingStatus();
  }
}
