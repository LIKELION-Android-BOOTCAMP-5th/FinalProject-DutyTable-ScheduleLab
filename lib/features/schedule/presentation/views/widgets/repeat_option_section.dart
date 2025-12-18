import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepeatOptionSection extends StatelessWidget {
  final bool isRepeat;
  final bool weekendException;
  final bool holidayException;
  final ValueChanged<bool> onWeekendException;
  final ValueChanged<bool> onHolidayException;

  /// 반복 옵션 - 일정 반복(false - 비활성, true - 활성)
  /// 일정 반복 true 시
  /// N + SelectBox(일 마다, 주 마다, 개월 마다, 년 마다) + 반복횟수(숫자입력) => 필수
  /// 주말 제외 + 공휴일 제외 => 선택
  const RepeatOptionSection({
    super.key,
    required this.isRepeat,
    required this.weekendException,
    required this.holidayException,
    required this.onWeekendException,
    required this.onHolidayException,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRepeat) return const SizedBox();

    return Column(
      children: [
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
    return Container(
      padding: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.commonGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: isCheck,
            onChanged: (value) => onChanged(value ?? false),
          ),
          Text(label),
        ],
      ),
    );
  }
}
