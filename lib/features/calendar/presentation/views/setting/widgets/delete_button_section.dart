import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:flutter/material.dart';

class DeleteButtonSection extends StatelessWidget {
  const DeleteButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            CustomConfirmationDialog.show(
              context,
              content: "캘린더를 삭제하시겠습니까?",
              confirmColor: AppColors.commonRed,
              onConfirm: () {},
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BottomAppBar(
              height: 52,
              color: AppColors.commonRed,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, color: AppColors.commonWhite),
                  SizedBox(width: 4),
                  Text(
                    "캘린더 삭제",
                    style: TextStyle(
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
