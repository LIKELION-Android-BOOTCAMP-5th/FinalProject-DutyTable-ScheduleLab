import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final ValueChanged<String> onTitle;

  /// 일정 추가 - 일정 제목
  const TitleSection({super.key, required this.title, required this.onTitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 제목",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(
          initialValue: title,
          onChanged: onTitle,
          style: TextStyle(color: AppColors.textMain(context)),
          decoration: InputDecoration(
            hintText: "일정 제목을 추가해주세요",
            hintStyle: TextStyle(
              color: AppColors.textSub(context),
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: AppColors.surface(context),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColors.dBorder : AppColors.lBorder,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.primary(context),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
