import 'package:flutter/material.dart';

import '../../../../core/configs/app_colors.dart';

class CustomAppBarIcon extends StatelessWidget {
  /// 아이콘
  final IconData icon;

  /// 실행 함수
  final void Function() onTap;

  /// 커스텀 캘린더 앱바 아이콘
  const CustomAppBarIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // 리플 없는 버튼
    return GestureDetector(
      // 전체 영역 터치 가능
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 28, color: AppColors.textMain(context)),
      ),
    );
  }
}
