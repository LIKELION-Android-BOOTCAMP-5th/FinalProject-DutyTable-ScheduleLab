import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class RepeatOptionSection extends StatelessWidget {
  final bool isRepeat;
  final bool weekendException;
  final bool holidayException;
  final int repeatCount;
  final int repeatNum;
  final String repeatOption;
  final int itemCount;
  final DateTime today;
  final ValueChanged<bool> onWeekendException;
  final ValueChanged<bool> onHolidayException;
  final ValueChanged<int> onRepeatCount;
  final ValueChanged<int> onRepeatNum;
  final ValueChanged<String> onRepeatOption;
  final ValueChanged<DateTime> onSelectedDate;
  final List<DateTime> excludedDates; // 1. 리스트 추가
  final ValueChanged<int> onRemoveDate; // 2. 삭제 콜백 추가

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
    required this.repeatNum,
    required this.repeatOption,
    required this.itemCount,
    required this.onWeekendException,
    required this.onHolidayException,
    required this.onRepeatCount,
    required this.onRepeatNum,
    required this.onRepeatOption,
    required this.today,
    required this.onSelectedDate,
    required this.excludedDates,
    required this.onRemoveDate,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRepeat) return const SizedBox();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Opacity(
          opacity: isRepeat ? 1.0 : 0.4,
          child: IgnorePointer(
            ignoring: !isRepeat,
            child: Row(
              children: [
                /// 반복 주기
                Expanded(
                  flex: 1,
                  child: Text(
                    "반복 주기",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                /// 숫자 입력 필드
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    initialValue: repeatNum.toString(),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.textMain(context)),
                    onChanged: (value) => onRepeatNum(int.tryParse(value) ?? 1),
                    decoration: _inputDecoration(context),
                  ),
                ),

                const SizedBox(width: 10),

                /// 드롭다운
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: AppColors.surface(context),
                    style: TextStyle(color: AppColors.textMain(context)),
                    initialValue: repeatOption,
                    onChanged: (value) {
                      if (value != null) onRepeatOption(value);
                    },
                    decoration: _inputDecoration(context),
                    items: const [
                      DropdownMenuItem(value: "daily", child: Text("일")),
                      DropdownMenuItem(value: "weekly", child: Text("주")),
                      DropdownMenuItem(value: "monthly", child: Text("개월")),
                      DropdownMenuItem(value: "yearly", child: Text("년")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        /// 반복 횟수
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
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

            Expanded(flex: 2, child: const SizedBox.shrink()),

            Expanded(
              flex: 1,
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

        const SizedBox(height: 8),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: excludedDates.length,
          itemBuilder: (context, index) {
            final date = excludedDates[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.dBorder : AppColors.lBorder,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: AppColors.textMain(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () => onRemoveDate(index),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        _OptionAddCard(
          context: context,
          today: today,
          onSelectedDate: onSelectedDate,
        ),
      ],
    );
  }
}

class _OptionAddCard extends StatelessWidget {
  final BuildContext context;
  final DateTime today;
  final ValueChanged<DateTime> onSelectedDate;

  const _OptionAddCard({
    required this.context,
    required this.today,
    required this.onSelectedDate,
  });

  Future<void> _pickDate(
    BuildContext context,
    DateTime initial,
    ValueChanged<DateTime> onSelected,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
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

    return GestureDetector(
      onTap: () {
        _pickDate(context, today, onSelectedDate);
      },
      child: Container(
        width: double.maxFinite,
        height: 48,
        padding: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.dBorder : AppColors.lBorder,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            "제외 날짜 추가",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textSub(context),
            ),
          ),
        ),
      ),
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

InputDecoration _inputDecoration(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return InputDecoration(
    filled: true,
    fillColor: AppColors.surface(context),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      borderSide: BorderSide(color: AppColors.primary(context), width: 2),
    ),
  );
}
