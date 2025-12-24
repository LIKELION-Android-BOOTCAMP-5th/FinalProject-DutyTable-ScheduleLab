import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/schedule_edit_view_model.dart';

class ScheduleDetailButtonSection extends StatelessWidget {
  const ScheduleDetailButtonSection({super.key});

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
                buttonColor: AppColors.textSub(context),
                onTap: () async {
                  if (viewModel.state != DetailViewState.success ||
                      viewModel.schedule == null) {
                    return;
                  }

                  final result = await context.push<bool>(
                    '/schedule/detail/edit',
                    extra: {
                      'schedule': viewModel.schedule!,
                      'isAdmin': viewModel.isAdmin,
                    },
                  );

                  if (result == true) {
                    await viewModel.fetchUpdatedSchedule();

                    if (!context.mounted) return;
                    if (viewModel.state == DetailViewState.deleted) {
                      context.pop(true);
                    }
                  }
                },
              ),
              const SizedBox(width: 10),
            ],

            _ScheduleActionButton(
              icon: Icons.share,
              label: "공유",
              buttonColor: AppColors.primary(context),
              onTap: () => viewModel.shareSchedule(),
            ),

            if (isAdmin) ...[
              const SizedBox(width: 10),
              _ScheduleActionButton(
                icon: Icons.delete,
                label: "삭제",
                buttonColor: AppColors.danger(context),
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

Future<void> _showDeleteDialog(
  BuildContext context,
  ScheduleDetailViewModel viewModel,
) {
  final bgColor = AppColors.surface(context);
  final mainTextColor = AppColors.textMain(context);
  final subTextColor = AppColors.textSub(context);
  final dangerColor = AppColors.danger(context);

  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: bgColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "일정을 삭제하시겠습니까?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: mainTextColor,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                /// 일정 삭제 다이얼로그 - 취소
                Expanded(
                  child: _DialogButton(
                    label: "취소",
                    buttonColor: subTextColor,
                    textColor: AppColors.pureWhite,
                    onTap: () => context.pop(),
                  ),
                ),

                const SizedBox(width: 10),

                /// 일정 삭제 다이얼로그 - 확인
                Expanded(
                  child: _DialogButton(
                    label: "확인",
                    buttonColor: dangerColor,
                    textColor: AppColors.pureWhite,
                    onTap: () async {
                      await viewModel.deleteSchedule();

                      if (!context.mounted) return;

                      if (context.canPop()) {
                        context.pop();
                      }
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
  final Color buttonColor;
  final Color? textColor;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.buttonColor,
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
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor ?? AppColors.textMain(context),
          ),
        ),
      ),
    );
  }
}
