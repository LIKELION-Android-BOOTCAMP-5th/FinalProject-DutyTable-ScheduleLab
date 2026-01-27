import 'package:dutytable/features/onboarding/data/models/onboarding_model.dart';
import 'package:dutytable/features/onboarding/domain/entities/onboarding_entity.dart';

extension OnboardingModelMapper on OnboardingModel {
  OnboardingEntity toEntity() {
    return OnboardingEntity(title: title, body: body, image: image);
  }
}

extension OnboardingEntityMapper on OnboardingEntity {
  OnboardingModel toModel() {
    return OnboardingModel(title: title, body: body, image: image);
  }
}
