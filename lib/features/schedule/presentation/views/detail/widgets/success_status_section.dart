import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 일정 상세 - 완료 여부
class SuccessStatusSection extends StatelessWidget {
  const SuccessStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "완료",
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          Switch(
            value: viewModel.isDone,
            onChanged: (value) => viewModel.isDone = value,
          ),
        ],
      ),
    );
  }
}
