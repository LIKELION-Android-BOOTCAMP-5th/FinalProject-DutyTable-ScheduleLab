import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final ValueChanged<String> onTitle;

  /// 일정 추가 - 일정 제목
  const TitleSection({super.key, required this.title, required this.onTitle});

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
          initialValue: title,
          onChanged: onTitle,
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
