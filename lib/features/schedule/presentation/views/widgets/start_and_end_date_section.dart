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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "일정 날짜",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder(context), width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "시작일",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickDate(context, startDate, onStartDate),
                      child: Text(
                        "${startDate.year}.${startDate.month}.${startDate.day}",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "종료일",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _pickDate(context, endDate, onEndDate),
                      child: Text(
                        "${endDate.year}.${endDate.month}.${endDate.day}",
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
