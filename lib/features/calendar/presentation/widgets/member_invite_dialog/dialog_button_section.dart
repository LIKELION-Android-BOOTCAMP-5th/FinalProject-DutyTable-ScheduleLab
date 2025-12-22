import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogButtonSection extends StatelessWidget {
  final SharedCalendarViewModel viewModel;
  const DialogButtonSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewModel.onConfirm();
        context.pop();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '완료',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.pureWhite,
          ),
        ),
      ),
    );
  }
}
