import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class LeftActions extends StatelessWidget {
  /// 공유 캘린더 목록 - 앱바 :  왼쪽 로고 + 타이틀
  const LeftActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/calendar_logo.png",
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        ),
        const SizedBox(width: 4),
        Text(
          "DutyTable",
          style: TextStyle(
            color: AppColors.textMain(context),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
