import 'package:dutytable/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FinishOnboardingUseCase {
  final OnboardingRepository repository;

  FinishOnboardingUseCase(this.repository);

  Future<void> call() {
    return repository.finishOnboarding();
  }
}
