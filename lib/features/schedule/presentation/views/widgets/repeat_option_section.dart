import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class RepeatOptionSection extends StatelessWidget {
  final bool isRepeat;
  final bool weekendException;
  final bool holidayException;
  final int repeatCount;
  final int repeatNum;
  final String repeatOption;
  final String endOption; // 'count' 또는 'date'
  final DateTime endDate;
  final DateTime today;
  final List<DateTime> excludedDates;

  final ValueChanged<bool> onWeekendException;
  final ValueChanged<bool> onHolidayException;
  final ValueChanged<int> onRepeatCount;
  final ValueChanged<int> onRepeatNum;
  final ValueChanged<String> onRepeatOption;
  final ValueChanged<String> onEndOption; // 종료 옵션 변경 콜백
  final ValueChanged<DateTime> onEndDate; // 종료 날짜 변경 콜백
  final ValueChanged<DateTime> onSelectedDate;
  final ValueChanged<int> onRemoveDate;

  const RepeatOptionSection({
    super.key,
    required this.isRepeat,
    required this.weekendException,
    required this.holidayException,
    required this.repeatCount,
    required this.repeatNum,
    required this.repeatOption,
    required this.endOption,
    required this.endDate,
    required this.today,
    required this.excludedDates,
    required this.onWeekendException,
    required this.onHolidayException,
    required this.onRepeatCount,
    required this.onRepeatNum,
    required this.onRepeatOption,
    required this.onEndOption,
    required this.onEndDate,
    required this.onSelectedDate,
    required this.onRemoveDate,
  });

  BoxDecoration _containerDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: AppColors.surface(context),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isDark ? AppColors.dBorder : AppColors.lBorder,
        width: 2,
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    DateTime initial,
    ValueChanged<DateTime> onSelected,
  ) async {
    // 키보드가 열려있다면 닫아줍니다.
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
    if (!isRepeat) return const SizedBox();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1. 반복 주기 설정
        Row(
          children: [
            Expanded(flex: 1, child: _SectionLabel("반복 주기", context)),
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
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface(context),
                style: TextStyle(color: AppColors.textMain(context)),
                initialValue: repeatOption,
                onChanged: (value) =>
                    value != null ? onRepeatOption(value) : null,
                decoration: _inputDecoration(context),
                items: const [
                  DropdownMenuItem(value: "daily", child: Text("일 마다")),
                  DropdownMenuItem(value: "weekly", child: Text("주 마다")),
                  DropdownMenuItem(value: "monthly", child: Text("개월 마다")),
                  DropdownMenuItem(value: "yearly", child: Text("년 마다")),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// 2. 반복 종료 설정 (횟수 vs 날짜)
        _SectionLabel("반복 종료", context),
        const SizedBox(height: 8),
        Row(
          children: [
            _toggleButton(
              context,
              "횟수 기준",
              endOption == 'count',
              () => onEndOption('count'),
            ),
            const SizedBox(width: 8),
            _toggleButton(
              context,
              "날짜 기준",
              endOption == 'date',
              () => onEndOption('date'),
            ),
          ],
        ),
        const SizedBox(height: 10),

        /// 3. 종료 옵션에 따른 입력창
        if (endOption == 'count')
          Row(
            children: [
              const Spacer(flex: 2),
              Expanded(
                flex: 1,
                child: TextFormField(
                  // key를 추가하여 값이 바뀔 때 UI 강제 갱신
                  key: ValueKey("count_$repeatCount"),
                  textAlign: TextAlign.center,
                  initialValue: repeatCount.toString(),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: AppColors.textMain(context)),
                  onChanged: (value) => onRepeatCount(int.tryParse(value) ?? 1),
                  decoration: _inputDecoration(
                    context,
                  ).copyWith(suffixText: "회"),
                ),
              ),
            ],
          )
        else
          GestureDetector(
            onTap: () => _pickDate(context, endDate, onEndDate),
            child: Container(
              // key를 부여하여 데이터 변경 시 위젯 트리를 갱신하도록 명시
              key: ValueKey("date_$endDate"),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: _containerDecoration(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // String 포맷팅 확인
                    "${endDate.year}.${endDate.month.toString().padLeft(2, '0')}.${endDate.day.toString().padLeft(2, '0')} 까지",
                    style: TextStyle(
                      color: AppColors.textMain(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.primary(context),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 16),

        /// 4. 예외 옵션 (주말/공휴일)
        Row(
          children: [
            Expanded(
              child: _OptionCard(
                context: context,
                label: "주말 제외",
                isCheck: weekendException,
                onChanged: onWeekendException,
              ),
            ),
            const SizedBox(width: 10),
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

        const SizedBox(height: 16),
        _SectionLabel("특정 제외 날짜", context),
        const SizedBox(height: 8),

        /// 5. 제외 날짜 리스트
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: excludedDates.length,
          itemBuilder: (context, index) {
            final date = excludedDates[index];
            return _ExcludedDateTile(
              date: date,
              onRemove: () => onRemoveDate(index),
              isDark: isDark,
            );
          },
        ),
        _OptionAddCard(
          context: context,
          today: today,
          onSelectedDate: onSelectedDate,
        ),
      ],
    );
  }

  /// 섹션 타이틀 라벨
  Widget _SectionLabel(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textMain(context),
      ),
    );
  }

  /// 종료 옵션 선택용 토글 버튼
  Widget _toggleButton(
    BuildContext context,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary(context)
                : AppColors.surface(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary(context)
                  : AppColors.lBorder,
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSub(context),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// --- 보조 위젯들 (스타일 유지 및 리팩토링) ---

class _ExcludedDateTile extends StatelessWidget {
  final DateTime date;
  final VoidCallback onRemove;
  final bool isDark;

  const _ExcludedDateTile({
    required this.date,
    required this.onRemove,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.dBorder : AppColors.lBorder,
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
            icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 20),
            onPressed: onRemove,
          ),
        ],
      ),
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
