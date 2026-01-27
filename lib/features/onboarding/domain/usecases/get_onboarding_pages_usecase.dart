import 'package:dutytable/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:dutytable/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOnboardingPagesUseCase {
  final OnboardingRepository repository;

  GetOnboardingPagesUseCase(this.repository);

  List<OnboardingEntity> call() {
    return repository.getOnboardingPages();
  }
}
