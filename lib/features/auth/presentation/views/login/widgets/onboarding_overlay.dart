import 'package:dutytable/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:flutter/material.dart';

class OnboardingOverlay extends StatelessWidget {
  final bool visible;
  final VoidCallback onFinished;

  const OnboardingOverlay({
    super.key,
    required this.visible,
    required this.onFinished,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return OnboardingScreen(
      onFinished: onFinished,
    );
  }
}
