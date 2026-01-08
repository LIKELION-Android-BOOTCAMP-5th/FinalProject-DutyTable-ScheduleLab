import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 일정 상세 - 일정 날짜 및 시간
class ScheduleDateTime extends StatelessWidget {
  const ScheduleDateTime({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text("🕒", style: TextStyle(fontSize: 20)),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 일정 날짜 - 시작일 ~ 종료일
              Row(
                children: [
                  Text(
                    viewModel.startedAt
                        .toString()
                        .toDateTime()
                        .koreanShortDateWithWeekday,
                    style: TextStyle(
                      color: AppColors.textMain(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "~",
                    style: TextStyle(
                      color: AppColors.textMain(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    viewModel.endedAt
                        .toString()
                        .toDateTime()
                        .koreanShortDateWithWeekday,
                    style: TextStyle(
                      color: AppColors.textMain(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              /// 일정 날짜 - 시작일 ~ 종료일
              Row(
                children: [
                  Text(
                    viewModel.startedAt.toString().toDateTime().koreanAmPmTime,
                    style: TextStyle(
                      color: AppColors.textSub(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 30,
                    color: AppColors.iconSub(context),
                  ),

                  Text(
                    viewModel.endedAt.toString().toDateTime().koreanAmPmTime,
                    style: TextStyle(
                      color: AppColors.textSub(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
