import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthButtonsSection extends StatelessWidget {
  final bool showApple;
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const AuthButtonsSection({
    super.key,
    required this.showApple,
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: GestureDetector(
            onTap: onGoogleTap,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                '구글로 계속하기',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
        ),
        if (showApple) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: SignInWithAppleButton(
              onPressed: onAppleTap,
            ),
          ),
        ],
      ],
    );
  }
}
