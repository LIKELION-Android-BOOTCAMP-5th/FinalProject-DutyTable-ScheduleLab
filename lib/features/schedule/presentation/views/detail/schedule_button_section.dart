import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScheduleButtonSection extends StatelessWidget {
  const ScheduleButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ScheduleDetailViewModel>();
    final isAdmin = context.select<ScheduleDetailViewModel, bool>(
      (vm) => vm.isAdmin,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
        child: Row(
          children: [
            if (isAdmin) ...[
              _ScheduleActionButton(
                icon: Icons.edit_note,
                label: "편집",
                borderColor: AppColors.commonGrey,
                onTap: () => print("편집"),
              ),
              const SizedBox(width: 10),
            ],

            _ScheduleActionButton(
              icon: Icons.share,
              label: "공유",
              borderColor: AppColors.commonBlue,
              onTap: () => print("공유"),
            ),

            if (isAdmin) ...[
              const SizedBox(width: 10),
              _ScheduleActionButton(
                icon: Icons.delete,
                label: "삭제",
                borderColor: AppColors.commonRed,
                onTap: () => _showDeleteDialog(context, viewModel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScheduleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color borderColor;
  final Color? textColor;
  final VoidCallback onTap;

  const _ScheduleActionButton({
    required this.icon,
    required this.label,
    required this.borderColor,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? borderColor;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background(context),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showDeleteDialog(
  BuildContext context,
  ScheduleDetailViewModel viewModel,
) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: AppColors.background(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "일정을 삭제하시겠습니까?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                /// 일정 삭제 다이얼로그 - 취소
                Expanded(
                  child: _DialogButton(
                    label: "취소",
                    color: const Color(0xfff3f4f6),
                    onTap: () => context.pop(),
                  ),
                ),

                const SizedBox(width: 10),

                /// 일정 삭제 다이얼로그 - 확인
                Expanded(
                  child: _DialogButton(
                    label: "확인",
                    color: const Color(0xffef4444),
                    textColor: Colors.white,
                    onTap: () async {
                      await viewModel.deleteSchedules(viewModel.scheduleId);
                      context.pop();
                      context.pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
