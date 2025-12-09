import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemoSection extends StatelessWidget {
  /// 일정 추가 - 메모
  const MemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "메모",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        TextFormField(
          maxLength: 300,
          maxLines: 4,
          onChanged: (value) => viewModel.memo = value,
          decoration: InputDecoration(
            hintText: "메모를 입력하세요 (최대 300자)",
            border: OutlineInputBorder(
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
