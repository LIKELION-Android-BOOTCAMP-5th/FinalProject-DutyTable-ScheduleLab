import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ScheduleDialogHeader extends StatelessWidget {
  final DateTime day;

  /// 일정 더보기 다이얼로그 - 헤더
  const ScheduleDialogHeader({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleViewModel>();

    // 1. 기본 권한: 내가 이 캘린더의 방장인가?
    final isCalendarAdmin =
        viewModel.calendar?.userId == viewModel.currentUserId;

    // 2. 추가 체크: 현재 선택된 날(day)의 일정 중 '내 것(삭제 가능한 것)'이 하나라도 있는가?
    final hasDeletableItem = viewModel.displaySchedules
        .where((s) => s.containsDay(day))
        .any((s) => s.calendarId == viewModel.calendar?.id);

    // 최종 노출 조건: 방장이어야 하며, 삭제할 수 있는 내 일정이 존재해야 함
    final showDeleteOption = isCalendarAdmin && hasDeletableItem;

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
          if (showDeleteOption)
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

                    // 아무것도 선택하지 않았을 때는 삭제 동작 방지
                    if (viewModel.selectedIds.isEmpty) return;

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
