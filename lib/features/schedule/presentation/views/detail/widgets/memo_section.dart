import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 일정 상세 - 메모
class MemoSection extends StatelessWidget {
  const MemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IgnorePointer(
        ignoring: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "메모",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain(context),
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              initialValue: viewModel.memo,
              maxLength: 300,
              maxLines: 4,
              style: TextStyle(color: AppColors.textMain(context)),
              decoration: InputDecoration(
                hintText: "메모를 입력하세요 (최대 300자)",
                hintStyle: TextStyle(color: AppColors.textSub(context)),
                filled: true,
                fillColor: AppColors.surface(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.dBorder : AppColors.lBorder,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
