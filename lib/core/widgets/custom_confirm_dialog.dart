import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomConfirmationDialog extends StatelessWidget {
  /// 내용
  final String content;

  /// 확인 버튼 색상
  final Color confirmColor;

  /// 확인 버튼 클릭 시 실행
  final VoidCallback onConfirm;

  const CustomConfirmationDialog({
    super.key,
    required this.content,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 다이얼로그 제목
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  /// 취소 버튼
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// 확인 버튼
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                        // 전달받은 함수 실행
                        onConfirm();
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: confirmColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
