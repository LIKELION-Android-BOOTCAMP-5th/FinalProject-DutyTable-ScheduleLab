import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  /// 일정 추가 - 일정 제목
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 제목",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        TextFormField(
          decoration: InputDecoration(
            hintText: "일정 제목을 추가해주세요",
            hintStyle: TextStyle(
              color: AppColors.commonGrey,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: AppColors.card(context),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.cardBorder(context),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.cardBorder(context),
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
