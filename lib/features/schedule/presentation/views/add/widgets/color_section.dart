import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorSection extends StatelessWidget {
  /// 일정 추가 - 컬러 세션
  const ColorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

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
          children: ScheduleAddViewModel.colorList.map((color) {
            final isSelected = color == viewModel.selectedColor;

            return GestureDetector(
              onTap: () => viewModel.selectedColor = color,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AnimatedScale(
                  scale: isSelected ? 1.25 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(color),
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
