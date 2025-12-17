import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/calendar_setting_view_model.dart';

class DeleteButtonSection extends StatelessWidget {
  const DeleteButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarSettingViewModel>();
    final isAdmin = viewModel.calendar.user_id == viewModel.currentUser!.id;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            isAdmin
                ? CustomConfirmationDialog.show(
                    context,
                    content: "캘린더를 삭제하시겠습니까?",
                    confirmColor: AppColors.commonRed,
                    onConfirm: () async {
                      CustomConfirmationDialog.show(
                        context,
                        content: "정말 삭제 하시겠습니까?",
                        contentColor: AppColors.commonRed,
                        confirmColor: AppColors.commonRed,
                        onConfirm: () async {
                          await viewModel.deleteCalendar();
                          context.go(
                            '/shared',
                            extra: {
                              'refresh': true,
                              'signalId': DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                            },
                          );
                        },
                      );
                    },
                  )
                : CustomConfirmationDialog.show(
                    context,
                    content: "캘린더를 나가시겠습니까?",
                    confirmColor: AppColors.commonRed,
                    onConfirm: () async {
                      await viewModel.outCalendar();
                      context.go(
                        '/shared',
                        extra: {
                          'refresh': true,
                          'signalId': DateTime.now().millisecondsSinceEpoch
                              .toString(),
                        },
                      );
                    },
                  );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BottomAppBar(
              height: 52,
              color: AppColors.commonRed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isAdmin
                      ? const Icon(
                          Icons.delete_outline,
                          color: AppColors.commonWhite,
                        )
                      : SizedBox.shrink(),
                  const SizedBox(width: 4),
                  Text(
                    isAdmin ? "캘린더 삭제" : "캘린더 나가기",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.commonWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
