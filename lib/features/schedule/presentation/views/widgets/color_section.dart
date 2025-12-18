import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: colorList.map((color) {
            final isSelected = color == selectColor;

            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AnimatedScale(
                  scale: isSelected ? 1.25 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(int.parse(color)),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.commonGrey, width: 2)
                          : null,
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
