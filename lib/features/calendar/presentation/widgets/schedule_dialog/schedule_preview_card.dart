import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchedulePreviewCard extends StatelessWidget {
  final ScheduleModel item;

  /// 일정 더보기 - 바디 : 일정(요약 카드)
  const SchedulePreviewCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleViewModel>();
    final isSelected = viewModel.isSelected(item.id.toString());

    // 권한 확인: 현재 캘린더의 일정인지
    final bool isMySchedule = item.calendarId == viewModel.calendar?.id;

    final color = Color(int.parse(item.colorValue));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? color.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          // 내 일정이고 선택되었을 때만 붉은 테두리 표시
          border: viewModel.deleteMode && isSelected && isMySchedule
              ? Border.all(color: AppColors.pureDanger, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item.emotionTag ?? "🙂",
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 6, color: color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMain(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 삭제 모드이면서 + 내 일정인 경우에만 체크박스 노출
            if (viewModel.deleteMode && isMySchedule)
              Transform.scale(
                scale: 0.9,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) =>
                      viewModel.toggleSelected(item.id.toString()),
                  activeColor: AppColors.pureDanger,
                  side: BorderSide(color: AppColors.textSub(context)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
