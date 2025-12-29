import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';

class MyScheduleCheckBox extends StatelessWidget {
  final ScheduleViewModel viewModel;

  const MyScheduleCheckBox({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.calendar?.type == "personal") {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Checkbox(
            value: viewModel.isFetchMySchedule,
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
