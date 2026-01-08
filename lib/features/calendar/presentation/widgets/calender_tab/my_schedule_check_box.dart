import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';

class MyScheduleCheckBox extends StatelessWidget {
  final ScheduleViewModel viewModel;

  const MyScheduleCheckBox({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.calendar?.type == "personal") {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Checkbox(
              value: viewModel.isShowAllSchedule,
              onChanged: (_) => viewModel.toggleFetchAllSchedule(),
              activeColor: AppColors.primaryBlue,
              checkColor: AppColors.pureWhite,
              side: BorderSide(color: AppColors.textSub(context)),
            ),
            Text(
              "모든 일정 불러오기",
              style: TextStyle(color: AppColors.textMain(context)),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Checkbox(
            value: viewModel.isShowMySchedule,
            onChanged: (_) => viewModel.toggleFetchMySchedule(),
            activeColor: AppColors.primaryBlue,
            checkColor: AppColors.pureWhite,
            side: BorderSide(color: AppColors.textSub(context)),
          ),
          Text(
            "내 일정 불러오기",
            style: TextStyle(color: AppColors.textMain(context)),
          ),
        ],
      ),
    );
  }
}
