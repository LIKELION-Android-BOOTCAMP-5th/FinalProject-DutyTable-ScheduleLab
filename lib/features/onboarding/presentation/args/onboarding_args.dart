import 'dart:ui';

class OnboardingArgs {
  final int totalPages;
  final VoidCallback onFinished;

  OnboardingArgs({required this.totalPages, required this.onFinished});
}
