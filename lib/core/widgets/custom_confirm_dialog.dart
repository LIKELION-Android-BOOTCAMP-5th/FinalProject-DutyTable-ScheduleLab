import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../configs/app_colors.dart';

class CustomConfirmationDialog extends StatelessWidget {
  /// 내용
  final String content;

  final Color? contentColor;

  /// 확인 버튼 색상
  final Color confirmColor;

  /// 확인 버튼 클릭 시 실행
  final VoidCallback onConfirm;

  /// 취소 버튼 클릭 시 실행
  final VoidCallback? onCancel;

  /// 확인 버튼 텍스트
  final String? confirmText;

  /// 취소 버튼 텍스트
  final String? cancelText;

  const CustomConfirmationDialog({
    super.key,
    required this.content,
    this.contentColor,
    required this.confirmColor,
    required this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
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
                style: TextStyle(
                  color: contentColor ?? AppColors.textMain(context),
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
                          border: Border.all(
                            color: AppColors.textSub(context),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            cancelText ?? "취소",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSub(context),
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
                        child: Center(
                          child: Text(
                            confirmText ?? "확인",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.pureWhite,
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

  static Future<void> show(
    BuildContext context, {
    required String content,
    Color? contentColor,
    required Color confirmColor,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = false,
    String? confirmText,
    String? cancelText,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => CustomConfirmationDialog(
        content: content,
        contentColor: contentColor,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }
}
