import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScheduleAddButtonSection extends StatelessWidget {
  final int calendarId;
  final GlobalKey<FormState> formKey;

  /// 일정 추가 - 버튼 세션
  const ScheduleAddButtonSection({
    super.key,
    required this.formKey,
    required this.calendarId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleAddViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            /// 일정 추가 - 취소 버튼
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.card(context),
                  border: Border.all(color: AppColors.commonGrey, width: 1),
                ),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    "취소",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// 일정 추가 - 저장 버튼
            Expanded(
              child: GestureDetector(
                onTap: viewModel.state == ViewState.loading
                    ? null
                    : () async {
                        await viewModel.addSchedule(calendarId);
                        if (context.mounted) {
                          context.pop(true);
                        }
                      },
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.actionPositive(context),
                  ),
                  child: viewModel.state == ViewState.loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "저장",
                          style: TextStyle(
                            color: AppColors.commonWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
