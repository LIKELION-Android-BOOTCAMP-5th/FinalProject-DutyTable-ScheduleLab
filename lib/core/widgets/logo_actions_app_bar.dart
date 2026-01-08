import 'package:flutter/material.dart';

import '../configs/app_colors.dart';

class LogoActionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftActions;
  final Widget? rightActions;

  const LogoActionsAppBar({super.key, this.leftActions, this.rightActions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
      ),
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: AppColors.background(context),
        border: Border(
          bottom: BorderSide(color: AppColors.textSub(context), width: 1),
        ),
      ),
      child: Row(
        children: [
          // LEFT: 로고 + 텍스트
          if (leftActions != null) leftActions!,

          const Spacer(),

          // RIGHT: 캘린더 추가, 알림, 캘린더 삭제 등 아이콘 및 텍스트
          if (rightActions != null) rightActions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
