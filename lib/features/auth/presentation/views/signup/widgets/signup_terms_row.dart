import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class SignupTermsRow extends StatelessWidget {
  final bool isLoading;
  final bool hasViewedTerms;
  final bool isTermsAgreed;
  final ValueChanged<bool?> onToggleAgreement;
  final Future<void> Function() onViewTerms;

  const SignupTermsRow({
    super.key,
    required this.isLoading,
    required this.hasViewedTerms,
    required this.isTermsAgreed,
    required this.onToggleAgreement,
    required this.onViewTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isTermsAgreed,
          onChanged: isLoading || !hasViewedTerms ? null : onToggleAgreement,
          activeColor: AppColors.primaryBlue,
          side: BorderSide(color: AppColors.iconSub(context)),
          checkColor: AppColors.pureWhite,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '약관동의',
            style: TextStyle(
              color: AppColors.textMain(context),
              fontSize: 14,
            ),
          ),
        ),
        TextButton(
          onPressed: isLoading ? null : onViewTerms,
          child: const Text(
            '전체보기',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryBlue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
