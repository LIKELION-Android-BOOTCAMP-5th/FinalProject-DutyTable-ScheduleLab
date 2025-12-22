import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class ColorSection extends StatelessWidget {
  /// 색 리스트
  static const List<String> colorList = [
    "0xFFFF3B30",
    "0xFFFF9500",
    "0xFFFFCC00",
    "0xFF34C759",
    "0xFF32ADE6",
    "0xFF007AFF",
    "0xFFAF52DE",
  ];

  final String selectColor;
  final ValueChanged<String> onColorSelected;

  /// 일정 추가 - 컬러 세션
  const ColorSection({
    super.key,
    required this.selectColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "색 선정",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: colorList.map((color) {
            final isSelected = color == selectColor;

            return Expanded(
              // 부모 Row의 공간을 똑같이 나눠 가짐
              child: GestureDetector(
                onTap: () => onColorSelected(color),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedScale(
                    scale: isSelected ? 1.1 : 0.8,
                    duration: const Duration(milliseconds: 180),
                    child: AspectRatio(
                      aspectRatio: 1.0, // 가로세로 1:1 비율 유지 (원형)
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(int.parse(color)),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.textSub(context),
                                  width: 2,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
