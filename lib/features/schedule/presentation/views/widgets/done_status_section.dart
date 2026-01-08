import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoneStatusSection extends StatelessWidget {
  final bool isDone;
  final ValueChanged<bool> onIsDone;

  /// 완료 상태
  const DoneStatusSection({
    super.key,
    required this.isDone,
    required this.onIsDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 완료 상태",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.dBorder : AppColors.lBorder,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDone ? "완료됨" : "미완료",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: isDone
                      ? AppColors.primary(context)
                      : AppColors.textSub(context),
                ),
              ),

              Switch(
                value: isDone,
                onChanged: onIsDone,
                activeThumbColor: AppColors.pureWhite,
                activeTrackColor: AppColors.primary(context),
                inactiveThumbColor: isDark
                    ? AppColors.textSub(context)
                    : AppColors.pureWhite,
                inactiveTrackColor: isDark
                    ? AppColors.dBorder
                    : AppColors.lBorder,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
