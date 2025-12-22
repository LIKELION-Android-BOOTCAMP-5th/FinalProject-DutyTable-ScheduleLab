import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditButtonSection extends StatelessWidget {
  final CalendarEditViewModel viewModel;

  const EditButtonSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isContentChange =
        viewModel.titleController.text != viewModel.calendar.title ||
        viewModel.descController.text != viewModel.calendar.description ||
        viewModel.image?.path != viewModel.calendar.imageURL;

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
                        ),
                        backgroundColor: result
                            ? AppColors.pureSuccess
                            : AppColors.pureDanger,
                        duration: const Duration(seconds: 3),
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
