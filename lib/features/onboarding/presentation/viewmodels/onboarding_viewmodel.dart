import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;

  final int totalPages;

  final VoidCallback onFinished;

  OnboardingViewModel({required this.totalPages, required this.onFinished});

  void disposeController() {
    pageController.dispose();
  }

  void onPageChanged(int page) {
    currentPage = page;
    notifyListeners();
  }

  Future<void> goToNextPage() async {
    if (currentPage < totalPages - 1) {
      pageController.nextPage(
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isOnboardingDone", true);
    onFinished();
  }
}
