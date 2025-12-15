import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditButtonSection extends StatelessWidget {
  const EditButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              CustomConfirmationDialog(
                content: "수정 완료하시겠습니까?",
                onConfirm: () {
                  print("확인 눌림");
                  context.pop();
                },
                confirmColor: AppColors.commonBlue,
              );
            },
            child: BottomAppBar(
              color: AppColors.commonBlue,
              height: 52,
              child: Center(
                child: Text(
                  "수정 완료",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.commonWhite,
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
