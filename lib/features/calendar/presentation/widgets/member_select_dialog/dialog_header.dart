import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '닉네임 검색',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain(context),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: AppColors.iconSub(context)),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
