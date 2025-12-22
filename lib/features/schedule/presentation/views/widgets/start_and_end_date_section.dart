import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class StartAndEndDateSection extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onStartDate;
  final ValueChanged<DateTime> onEndDate;

  /// 일정 추가 - 시작일 ~ 종료일
  const StartAndEndDateSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDate,
    required this.onEndDate,
  });

  Future<void> _pickDate(
    BuildContext context,
    DateTime initial,
    ValueChanged<DateTime> onSelected,
  ) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 날짜",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.dBorder : AppColors.lBorder,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "시작일",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSub(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickDate(context, startDate, onStartDate),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        "${startDate.year}.${startDate.month}.${startDate.day}",
                        style: TextStyle(color: AppColors.textMain(context)),
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
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSub(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickDate(context, endDate, onEndDate),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        "${endDate.year}.${endDate.month}.${endDate.day}",
                        style: TextStyle(color: AppColors.textMain(context)),
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
