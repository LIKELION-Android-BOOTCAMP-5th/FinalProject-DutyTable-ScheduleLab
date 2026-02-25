import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/loading_dialog.dart';

class ScheduleDetailEditButtonSection extends StatelessWidget {
  const ScheduleDetailEditButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleEditViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 24.0),
        child: Row(
          children: [
            _ScheduleActionButton(
              icon: Icons.cancel_outlined,
              label: "취소",
              buttonColor: AppColors.danger(context),
              onTap: () => context.pop(),
            ),

            const SizedBox(width: 10),

            _ScheduleActionButton(
              icon: Icons.edit_note,
              label: "수정",
              buttonColor: AppColors.primary(context),
              onTap: () async {
                // 1. 전체 화면 로딩 표시
                showFullScreenLoading(context);

                try {
                  // 2. 수정 로직 실행 (상태가 success/error로 바뀔 때까지 대기)
                  if (viewModel.repeatGroupId != null) {
                    await viewModel.updateAllSchedulesInGroup();
                  } else {
                    await viewModel.updateSingleSchedule();
                  }

                  // 3. 비동기 작업 완료 후 Context 유효성 체크
                  if (!context.mounted) return;

                  // 4. 로딩 다이얼로그 닫기
                  hideLoading(context);

                  // 5. 뷰모델 상태에 따른 후속 처리
                  if (viewModel.state == EditViewState.success) {
                    // 성공 시 이전 화면(상세화면)으로 데이터 변경 신호(true)와 함께 이동
                    context.pop(true);
                  } else if (viewModel.state == EditViewState.error) {
                    // 에러 시 사용자 알림 (예: 스낵바)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("일정 수정 중 오류가 발생했습니다. 다시 시도해주세요."),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                } catch (e) {
                  // 6. 예외 발생 시 로딩은 닫아줌
                  if (context.mounted) {
                    hideLoading(context);
                    debugPrint("❌ Update Action Error: $e");
                  }
                }
              },
            ),
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
