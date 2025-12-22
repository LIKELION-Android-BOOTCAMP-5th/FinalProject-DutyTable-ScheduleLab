import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionSection extends StatelessWidget {
  /// 감정 이모지 리스트
  static const List<String> emotionList = ["😢", "😕", "🙂", "😐", "😊"];

  final String? selectedEmotion;
  final ValueChanged<String> onEmotionSelected;

  /// 일정 추가 - 감정 세션
  const EmotionSection({
    super.key,
    this.selectedEmotion,
    required this.onEmotionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "감정 설정",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: emotionList.map((emotion) {
            final isSelected = emotion == (selectedEmotion ?? "😢");

            return GestureDetector(
              onTap: () => onEmotionSelected(emotion),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AnimatedScale(
                  scale: isSelected ? 1.25 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Text(emotion, style: const TextStyle(fontSize: 28)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
