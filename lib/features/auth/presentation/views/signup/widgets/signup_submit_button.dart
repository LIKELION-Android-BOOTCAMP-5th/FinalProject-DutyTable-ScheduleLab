import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class SignupSubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback onTap;

  const SignupSubmitButton({
    super.key,
    required this.isLoading,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: enabled ? AppColors.primaryBlue : AppColors.textSub(context),
              borderRadius: BorderRadius.circular(15),
            ),
            child: isLoading
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primary(context),
                strokeWidth: 2,
              ),
            )
                : const Text(
              '완료',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.pureWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
