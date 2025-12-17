import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionSection extends StatelessWidget {
  /// 일정 추가 - 감정 세션
  const EmotionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "감정 설정",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ScheduleAddViewModel.emotionList.map((emotion) {
            final isSelected = emotion == viewModel.selectedEmotion;

            return GestureDetector(
              onTap: () => viewModel.selectedEmotion = emotion,
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
