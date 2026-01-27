import 'package:dutytable/features/onboarding/data/datasource/onboarding_local_data_source.dart';
import 'package:dutytable/features/onboarding/data/models/onboarding_model_mapper.dart';
import 'package:dutytable/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:dutytable/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource dataSource;

  OnboardingRepositoryImpl(this.dataSource);

  @override
  List<OnboardingEntity> getOnboardingPages() {
    return dataSource.onboardingPages().map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> finishOnboarding() {
    return dataSource.setOnboardingDone();
  }
}
