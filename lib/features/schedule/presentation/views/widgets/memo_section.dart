import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemoSection extends StatelessWidget {
  final String memo;
  final ValueChanged<String> onMemo;

  /// 일정 추가 - 메모
  const MemoSection({super.key, required this.memo, required this.onMemo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "메모",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),

        TextFormField(
          initialValue: memo,
          maxLength: 300,
          maxLines: 4,
          onChanged: onMemo,
          decoration: InputDecoration(
            hintText: "메모를 입력하세요 (최대 300자)",
            filled: true,
            fillColor: AppColors.card(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.cardBorder(context),
                width: 2,
              ),
            ),
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
          ),
        ),
      ],
    );
  }
}
