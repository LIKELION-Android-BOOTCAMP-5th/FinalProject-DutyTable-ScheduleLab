import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/extensions.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ScheduleDialogHeader extends StatelessWidget {
  final DateTime day;

  /// 일정 더보기 다이얼로그 - 헤더
  const ScheduleDialogHeader({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleViewModel>();
    final isAdmin = viewModel.calendar?.user_id == viewModel.currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 일정 더보기 다이얼로그 - 헤더 왼쪽 : ex) 10 수요일
          Row(
            children: [
              Text(
                day.day.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain(context),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                day.weekday.koreanWeekday,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain(context),
                ),
              ),
            ],
          ),

          /// 일정 더보기 다이얼로그 - 헤더 오른쪽 : 전체 삭제(삭제 모드 시 취소 + 삭제)
          if (isAdmin)
            Row(
              children: [
                // 삭제 모드일 때만 취소 버튼
                if (viewModel.deleteMode)
                  GestureDetector(
                    onTap: () {
                      viewModel.cancelDeleteMode();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text(
                        "취소",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSub(context),
                        ),
                      ),
                    ),
                  ),

                // 선택 삭제 및 삭제 버튼
                GestureDetector(
                  onTap: () async {
                    if (!viewModel.deleteMode) {
                      viewModel.toggleDeleteMode();
                      return;
                    }

                    // 삭제 전 확인 다이얼로그
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.surface(ctx),
                        title: Text(
                          "일정 삭제",
                          style: TextStyle(color: AppColors.textMain(ctx)),
                        ),
                        content: Text(
                          "선택한 일정을 삭제하시겠습니까?",
                          style: TextStyle(color: AppColors.textSub(ctx)),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context.pop(false),
                            child: Text(
                              "취소",
                              style: TextStyle(color: AppColors.textSub(ctx)),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.pop(true),
                            child: const Text(
                              "삭제",
                              style: TextStyle(
                                color: AppColors.pureDanger,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed != true) return;

                    await viewModel.deleteAllSchedules();
                    await viewModel.fetchSchedules();

                    viewModel.toggleDeleteMode();

                    if (context.mounted) context.pop();
                  },
                  child: Text(
                    viewModel.deleteMode ? "삭제" : "선택삭제",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: viewModel.deleteMode
                          ? (viewModel.selectedIds.isEmpty
                                ? AppColors.textSub(context)
                                : AppColors.pureDanger)
                          : AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
