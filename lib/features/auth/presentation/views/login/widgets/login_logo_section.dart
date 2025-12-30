import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class LoginLogoSection extends StatelessWidget {
  const LoginLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/calendar_logo.png',
          width: 180,
          height: 180,
        ),
        const SizedBox(height: 10),
        Text(
          'DutyTable',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "DutyTable에 오신걸 환영합니다!",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSub(context),
          ),
        ),
      ],
    );
  }
}
