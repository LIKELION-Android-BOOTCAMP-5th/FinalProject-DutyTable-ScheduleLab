import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogButtonSection extends StatelessWidget {
  const DialogButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: AppColors.commonBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '완료',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.commonWhite,
          ),
        ),
      ),
    );
  }
}
