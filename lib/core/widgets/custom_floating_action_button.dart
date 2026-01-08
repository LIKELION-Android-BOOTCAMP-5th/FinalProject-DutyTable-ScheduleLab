import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final int calendarId;
  final DateTime? date;

  /// 커스텀 플로팅 액션 버튼(제스처 디텍터 사용)
  const CustomFloatingActionButton({
    super.key,
    required this.calendarId,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        final result = await context.push(
          "/schedule/add",
          extra: {"calendarId": calendarId, "date": date},
        );

        if (result == true && context.mounted) {
          context.read<ScheduleViewModel>().fetchSchedules();
        }
      },
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.dBorder : AppColors.lBorder,
              blurRadius: 6.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // 버튼 내부에 아이콘을 중앙에 배치합니다.
        child: Center(child: Icon(Icons.add, color: AppColors.pureWhite)),
      ),
    );
  }
}
