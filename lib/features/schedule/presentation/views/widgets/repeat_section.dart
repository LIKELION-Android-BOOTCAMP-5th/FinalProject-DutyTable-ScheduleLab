import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepeatSection extends StatelessWidget {
  final bool isRepeat;
  final int repeatNum;
  final String repeatOption;

  final ValueChanged<bool> onRepeatToggle;
  final ValueChanged<int> onRepeatNum;
  final ValueChanged<String> onRepeatOption;

  /// 일정 반복 - 선택 사항(기본 값 - false, 체크 박스)
  const RepeatSection({
    super.key,
    required this.isRepeat,
    required this.repeatNum,
    required this.repeatOption,
    required this.onRepeatToggle,
    required this.onRepeatNum,
    required this.onRepeatOption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 반복",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: AppColors.commonBlue,
                    value: isRepeat,
                    onChanged: (value) => onRepeatToggle(value ?? false),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    "일정 반복",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              flex: 3,
              child: Opacity(
                opacity: isRepeat ? 1.0 : 0.4,
                child: IgnorePointer(
                  ignoring: !isRepeat,
                  child: Row(
                    children: [
                      /// 숫자 입력 필드
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          initialValue: repeatNum.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              onRepeatNum(int.tryParse(value) ?? 1),
                          decoration: _inputDecoration(context),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// 드롭다운
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          initialValue: repeatOption,
                          onChanged: (value) {
                            if (value != null) onRepeatOption(value);
                          },
                          decoration: _inputDecoration(context),
                          items: const [
                            DropdownMenuItem(
                              value: "daily",
                              child: Text("일 마다"),
                            ),
                            DropdownMenuItem(
                              value: "weekly",
                              child: Text("주 마다"),
                            ),
                            DropdownMenuItem(
                              value: "monthly",
                              child: Text("개월 마다"),
                            ),
                            DropdownMenuItem(
                              value: "yearly",
                              child: Text("년 마다"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(BuildContext context) {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.card(context),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.commonGrey, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.commonGrey, width: 2),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.commonGrey, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.commonGrey, width: 2),
    ),
  );
}
