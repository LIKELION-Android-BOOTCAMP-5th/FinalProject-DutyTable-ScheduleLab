import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class StartAndEndTimeSection extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ValueChanged<TimeOfDay> onStartTime;
  final ValueChanged<TimeOfDay> onEndTime;

  /// 일정 추가 - 시작 시간 ~ 종료 시간
  const StartAndEndTimeSection({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartTime,
    required this.onEndTime,
  });

  Future<void> _pickTime(
    BuildContext context,
    TimeOfDay initial,
    ValueChanged<TimeOfDay> onSelected,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final selected = await showTimePicker(
      context: context,
      initialTime: initial,
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
          "일정 시간",
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
                      "시작시간",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSub(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickTime(context, startTime, onStartTime),
                      child: Text(
                        startTime.format(context),
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
                      "종료시간",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSub(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickTime(context, endTime, onEndTime),
                      child: Text(
                        endTime.format(context),
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
