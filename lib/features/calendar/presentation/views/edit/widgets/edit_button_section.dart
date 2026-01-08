import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditButtonSection extends StatelessWidget {
  const EditButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarEditViewModel>();

    // 텍스트 변경 여부
    final bool isTitleChanged =
        viewModel.titleController.text != viewModel.initialCalendar.title;
    final bool isDescChanged =
        viewModel.descController.text !=
        (viewModel.initialCalendar.description ?? "");

    // 이미지 변경 여부
    final bool isImageChanged =
        viewModel.newImage != null ||
        viewModel.calendar.imageURL != viewModel.initialCalendar.imageURL;

    // 최종 변경 여부
    final bool isContentChange =
        isTitleChanged || isDescChanged || isImageChanged;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (isContentChange) {
                CustomConfirmationDialog.show(
                  context,
                  content: "수정 완료하시겠습니까?",
                  confirmColor: AppColors.primaryBlue,
                  onConfirm: () async {
                    final bool result = await viewModel.updateCalendarInfo();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result ? '수정이 완료 되었습니다' : '알 수 없는 에러가 발생하였습니다',
                          style: TextStyle(color: AppColors.textMain(context)),
                        ),
                        backgroundColor: result
                            ? AppColors.pureSuccess
                            : AppColors.pureDanger,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                      ),
                    );
                    context.pop();
                  },
                );
              } else {
                null;
              }
            },
            child: BottomAppBar(
              color: isContentChange
                  ? AppColors.primaryBlue
                  : AppColors.textSub(context),
              height: 52,
              child: Center(
                child: Text(
                  "수정 완료",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
