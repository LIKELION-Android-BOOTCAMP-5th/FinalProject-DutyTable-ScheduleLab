import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCalendarEditTextField extends StatelessWidget {
  /// 박스 위에 표시할 내용
  final Widget title;
  final TextEditingController controller;

  /// 커스텀 캘린더 수정 텍스트 필드
  const CustomCalendarEditTextField({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 8),
        TextField(
          minLines: 1,
          maxLines: null, // 높이 제한 없음
          controller: controller,
          keyboardType: TextInputType.multiline,
          style: TextStyle(color: AppColors.textMain(context)),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface(context),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? AppColors.dBorder : AppColors.lBorder,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary(context),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
