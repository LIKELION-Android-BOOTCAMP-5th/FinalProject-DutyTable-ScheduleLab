import 'package:dutytable/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  List<OnboardingEntity> getOnboardingPages();
  Future<void> finishOnboarding();
}
