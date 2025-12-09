import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepeatOptionSection extends StatelessWidget {
  /// 반복 옵션 - 일정 반복(false - 비활성, true - 활성)
  /// 일정 반복 true 시
  /// N + SelectBox(일 마다, 주 마다, 개월 마다, 년 마다) + 반복횟수(숫자입력) => 필수
  /// 주말 제외 + 공휴일 제외 => 선택
  const RepeatOptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

    if (!viewModel.isRepeat) return const SizedBox();

    return Column(
      children: [
        Row(
          children: [
            /// 주말 제외
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.commonGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: viewModel.excludeWeekend,
                      onChanged: (value) =>
                          viewModel.excludeWeekend = value ?? false,
                    ),
                    const Text("주말 제외"),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// 공휴일 제외
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.commonGrey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: viewModel.excludeHoliday,
                      onChanged: (value) =>
                          viewModel.excludeHoliday = value ?? false,
                    ),
                    const Text("공휴일 제외"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
