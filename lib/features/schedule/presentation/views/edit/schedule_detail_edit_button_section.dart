import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScheduleDetailEditButtonSection extends StatelessWidget {
  const ScheduleDetailEditButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleEditViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
        child: Row(
          children: [
            _ScheduleActionButton(
              icon: Icons.cancel_outlined,
              label: "취소",
              buttonColor: AppColors.danger(context),
              onTap: () => context.pop(),
            ),

            const SizedBox(width: 10),

            _ScheduleActionButton(
              icon: Icons.edit_note,
              label: "수정",
              buttonColor: AppColors.primary(context),
              onTap: () async {
                await viewModel.updateSchedule();

                if (!context.mounted) return;

                context.pop(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color buttonColor;
  final VoidCallback onTap;

  const _ScheduleActionButton({
    required this.icon,
    required this.label,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background(context),
            border: Border.all(color: buttonColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: buttonColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
