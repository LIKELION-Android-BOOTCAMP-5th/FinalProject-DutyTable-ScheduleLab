import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EmotionColorSection extends StatelessWidget {
  /// 일정 상세 - 감정 및 색
  const EmotionColorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(viewModel.emotionTag ?? "😢", style: TextStyle(fontSize: 26)),

          const SizedBox(width: 16),

          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(int.parse(viewModel.colorValue)),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.dBorder : AppColors.lBorder,
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
