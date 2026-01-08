import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showFullScreenLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 사용자가 다이얼로그 바깥을 탭하여 닫을 수 없도록 설정
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primary(context),
          strokeWidth: 2,
          strokeCap: StrokeCap.round,
        ),
      );
    },
  );
}

// 다이얼로그를 닫는 함수
void hideLoading(BuildContext context) {
  if (context.mounted) {
    context.pop();
  }
}
