import 'package:dutytable/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:dutytable/features/onboarding/domain/usecases/finish_onboarding_use_case.dart';
import 'package:dutytable/features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class OnboardingViewModel extends ChangeNotifier {
  //-------------------- UseCase --------------------

  final GetOnboardingPagesUseCase _getOnboardingPagesUseCase;
  final FinishOnboardingUseCase _finishOnboardingUseCase;

  //-------------------- Entity --------------------

  late final List<OnboardingEntity> pages;
  final VoidCallback onFinished;

  //-------------------- UI --------------------

  final PageController pageController = PageController();
  int currentPage = 0;

  //-------------------- Getters --------------------

  int get totalPages => pages.length;

  //-------------------- Constructor --------------------

  OnboardingViewModel(
    this._getOnboardingPagesUseCase,
    this._finishOnboardingUseCase,
    @factoryParam this.onFinished,
  ) {
    pages = _getOnboardingPagesUseCase();
  }

  void onPageChanged(int page) {
    currentPage = page;
    notifyListeners();
  }

  Future<void> goToNextPage() async {
    if (currentPage < totalPages - 1) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await _finishOnboarding();
    }
  }

  Future<void> skip() async {
    await _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    await _finishOnboardingUseCase();
    onFinished();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
