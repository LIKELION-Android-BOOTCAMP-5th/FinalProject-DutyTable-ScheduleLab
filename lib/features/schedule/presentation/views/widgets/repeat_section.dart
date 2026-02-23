import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class RepeatSection extends StatelessWidget {
  final bool isRepeat;

  final ValueChanged<bool> onRepeatToggle;

  /// 일정 반복 - 선택 사항(기본 값 - false, 체크 박스)
  const RepeatSection({
    super.key,
    required this.isRepeat,
    required this.onRepeatToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onRepeatToggle(!isRepeat),
      behavior: HitTestBehavior.opaque, // Row의 빈 공간까지 탭을 감지하도록 설정
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ), // 탭 영역을 시각적으로 확보
            child: Text(
              "일정 반복",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain(context),
              ),
            ),
          ),
          Checkbox(
            activeColor: AppColors.primary(context),
            checkColor: AppColors.pureWhite,
            side: BorderSide(
              color: isDark ? AppColors.dBorder : AppColors.lBorder,
              width: 2,
            ),
            value: isRepeat,
            onChanged: (value) => onRepeatToggle(value ?? false),
          ),
        ],
      ),
    );
  }
}
