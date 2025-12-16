import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SaveButtonSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  /// 캘린더 추가 버튼
  const SaveButtonSection({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarAddViewModel>();
    final isEnabled = viewModel.isValid && !viewModel.isLoading;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.commonGrey, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: isEnabled
              ? () async {
                  if (formKey.currentState?.validate() != true) return;
                  try {
                    await viewModel.addSharedCalendar();
                    context.pop(true);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                }
              : null,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppColors.commonBlue
                  : AppColors.commonGreyShade400, // 비활성 색상
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: viewModel.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "저장",
                    style: TextStyle(
                      color: isEnabled
                          ? AppColors.commonWhite
                          : AppColors.commonGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
