import 'package:flutter/material.dart';

void showFullScreenLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 사용자가 다이얼로그 바깥을 탭하여 닫을 수 없도록 설정
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 4,
          strokeCap: StrokeCap.round,
        ),
      );
    },
  );
}

// 다이얼로그를 닫는 함수
void hideLoading(BuildContext context) {
  Navigator.of(context).pop();
}
