import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartAndEndTimeSection extends StatelessWidget {
  /// 일정 추가 - 시작 시간 ~ 종료 시간
  const StartAndEndTimeSection({super.key});

  // ✅ 시작 시간 선택
  Future<void> pickStartTime(BuildContext context) async {
    final viewModel = context.read<ScheduleAddViewModel>();

    final selected = await showTimePicker(
      context: context,
      initialTime: viewModel.startTime,
    );

    if (selected != null) {
      viewModel.startTime = selected;
    }
  }

  // ✅ 종료 시간 선택
  Future<void> pickEndTime(BuildContext context) async {
    final viewModel = context.read<ScheduleAddViewModel>();

    final selected = await showTimePicker(
      context: context,
      initialTime: viewModel.endTime,
    );

    if (selected != null) {
      viewModel.endTime = selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 시간",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder(context), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "시작시간",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => pickStartTime(context),
                      child: Consumer<ScheduleAddViewModel>(
                        builder: (_, vm, __) =>
                            Text(vm.startTime.format(context)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  children: [
                    Text(
                      "종료시간",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => pickEndTime(context),
                      child: Consumer<ScheduleAddViewModel>(
                        builder: (_, vm, __) =>
                            Text(vm.endTime.format(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
