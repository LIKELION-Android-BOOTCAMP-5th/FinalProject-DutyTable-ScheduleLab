import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoneStatusSection extends StatelessWidget {
  final bool isDone;
  final ValueChanged<bool> onIsDone;

  /// 완료 상태
  const DoneStatusSection({
    super.key,
    required this.isDone,
    required this.onIsDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "일정 완료 상태",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder(context), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "일정 완료 상태",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w800),
              ),

              Switch(value: isDone, onChanged: onIsDone),
            ],
          ),
        ),
      ],
    );
  }
}
