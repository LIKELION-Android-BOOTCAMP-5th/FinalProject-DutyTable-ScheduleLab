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

    // 제목이 입력되었고, 로딩 중이 아닐 때만 활성화
    final bool isEnabled =
        viewModel.title.trim().isNotEmpty &&
        viewModel.state != ViewState.loading;

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
                onTap: isEnabled
                    ? () async {
                        await viewModel.addSchedule(calendarId);
                        if (context.mounted &&
                            viewModel.state == ViewState.success) {
                          context.pop(true);
                        }
                      }
                    : null,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isEnabled
                        ? AppColors.actionPositive(context)
                        : AppColors.commonGrey.withOpacity(0.5),
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
