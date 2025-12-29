import 'package:dutytable/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:dutytable/features/onboarding/presentation/args/onboarding_args.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingViewModel extends ChangeNotifier {
  final OnboardingLocalDataSource localDataSource;
  final OnboardingArgs args;

  final PageController pageController = PageController();
  int currentPage = 0;

  int get totalPages => args.totalPages;
  VoidCallback get onFinished => args.onFinished;

  OnboardingViewModel(this.localDataSource, @factoryParam this.args);

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
    await localDataSource.setOnboardingDone();
    onFinished();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
