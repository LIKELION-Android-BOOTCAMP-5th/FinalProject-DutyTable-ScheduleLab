import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepeatToggleSection extends StatelessWidget {
  final bool isRepeat;
  final ValueChanged<bool> onRepeatToggle;

  const RepeatToggleSection({
    super.key,
    required this.isRepeat,
    required this.onRepeatToggle,
  });

  @override
  Widget build(BuildContext context) {
    // 상세 모드일 때 사용할 뷰모델
    final detailViewModel = context.read<ScheduleDetailViewModel?>();
    final displayIsRepeat = isRepeat ?? detailViewModel?.isRepeat ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "반복 설정",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              if (onRepeatToggle != null)
                Switch(value: displayIsRepeat, onChanged: onRepeatToggle),
            ],
          ),
          const SizedBox(height: 12),

          if (!displayIsRepeat)
            const Text("반복되지 않는 일정입니다.", style: TextStyle(fontSize: 16))
          else if (detailViewModel != null && onRepeatToggle == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  Icons.cached,
                  "${detailViewModel.repeatOption} / ${detailViewModel.repeatNum}회 간격",
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  Icons.repeat_on,
                  "총 ${detailViewModel.repeatCount}회 반복",
                ),

                // 주말/공휴일 제외 안내
                if (detailViewModel.weekendException ||
                    detailViewModel.holidayException) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.event_busy,
                    "${detailViewModel.weekendException ? '주말 제외' : ''}${detailViewModel.weekendException && detailViewModel.holidayException ? ', ' : ''}${detailViewModel.holidayException ? '공휴일 제외' : ''}",
                    contentColor: Colors.redAccent,
                  ),
                ],

                // [추가된 부분] 제외된 특정 날짜 목록
                if (detailViewModel.schedule?.excludedDates != null &&
                    detailViewModel.schedule!.excludedDates!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "사용자 지정 제외 날짜",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: detailViewModel.schedule!.excludedDates!.map((
                      date,
                    ) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          date, // YYYY-MM-DD 형식
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {Color? contentColor}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: contentColor ?? Colors.black87),
        ),
      ],
    );
  }
}
