import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartAndEndDateSection extends StatelessWidget {
  /// 일정 추가 - 시작일 ~ 종료일
  const StartAndEndDateSection({super.key});

  // ✅ 시작일 선택
  Future<void> pickStartDate(BuildContext context) async {
    final viewModel = context.read<ScheduleAddViewModel>();

    final selected = await showDatePicker(
      context: context,
      initialDate: viewModel.startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      viewModel.startDate = selected;
    }
  }

  // ✅ 종료일 선택
  Future<void> pickEndDate(BuildContext context) async {
    final viewModel = context.read<ScheduleAddViewModel>();

    final selected = await showDatePicker(
      context: context,
      initialDate: viewModel.endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      viewModel.endDate = selected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 날짜",
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
                      "시작일",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => pickStartDate(context),
                      child: Consumer<ScheduleAddViewModel>(
                        builder: (_, vm, __) => Text(
                          "${vm.startDate.year}.${vm.startDate.month}.${vm.startDate.day}",
                        ),
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
                      "종료일",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => pickEndDate(context),
                      child: Consumer<ScheduleAddViewModel>(
                        builder: (_, vm, __) => Text(
                          "${vm.endDate.year}.${vm.endDate.month}.${vm.endDate.day}",
                        ),
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
