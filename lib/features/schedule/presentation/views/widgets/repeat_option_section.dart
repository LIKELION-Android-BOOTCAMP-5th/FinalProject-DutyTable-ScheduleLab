import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepeatOptionSection extends StatelessWidget {
  final bool isRepeat;
  final bool weekendException;
  final bool holidayException;
  final int repeatCount;
  final ValueChanged<bool> onWeekendException;
  final ValueChanged<bool> onHolidayException;
  final ValueChanged<int> onRepeatCount;

  /// 반복 옵션 - 일정 반복(false - 비활성, true - 활성)
  /// 일정 반복 true 시
  /// N + SelectBox(일 마다, 주 마다, 개월 마다, 년 마다) + 반복횟수(숫자입력) => 필수
  /// 주말 제외 + 공휴일 제외 => 선택
  const RepeatOptionSection({
    super.key,
    required this.isRepeat,
    required this.weekendException,
    required this.holidayException,
    required this.repeatCount,
    required this.onWeekendException,
    required this.onHolidayException,
    required this.onRepeatCount,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRepeat) return const SizedBox();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        /// 반복 횟수
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "반복 횟수",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: repeatCount.toString(),
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.textMain(context)),
                onChanged: (value) => onRepeatCount(int.tryParse(value) ?? 1),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface(context),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.dBorder : AppColors.lBorder,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.dBorder : AppColors.lBorder,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primary(context),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            /// 주말 제외
            Expanded(
              child: _OptionCard(
                context: context,
                label: "주말 제외",
                isCheck: weekendException,
                onChanged: onWeekendException,
              ),
            ),

            const SizedBox(width: 10),

            /// 공휴일 제외
            Expanded(
              child: _OptionCard(
                context: context,
                label: "공휴일 제외",
                isCheck: holidayException,
                onChanged: onHolidayException,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final BuildContext context;
  final String label;
  final bool isCheck;
  final ValueChanged<bool> onChanged;

  const _OptionCard({
    required this.context,
    required this.label,
    required this.isCheck,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.dBorder : AppColors.lBorder,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            activeColor: AppColors.primary(context),
            checkColor: AppColors.pureWhite,
            side: BorderSide(
              color: isDark ? AppColors.textSub(context) : AppColors.lBorder,
              width: 2,
            ),
            value: isCheck,
            onChanged: (value) => onChanged(value ?? false),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textSub(context),
            ),
          ),
        ],
      ),
    );
  }
}
