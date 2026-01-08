import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'schedule_dialog_header.dart';
import 'schedule_preview_card.dart';

class ScheduleDialog extends StatelessWidget {
  final DateTime day;

  /// 일정 더보기 다이얼로그
  const ScheduleDialog({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Consumer<ScheduleViewModel>(
        builder: (_, viewModel, __) {
          final items = viewModel.displaySchedules
              .where((s) => s.containsDay(day))
              .toList();

          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 일정 더보기 - 헤더
                ScheduleDialogHeader(day: day),

                const Divider(height: 1),

                const SizedBox(height: 10),

                /// 일정 더보기 - 바디 : 일정
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () async {
                        // 1. 삭제 모드일 때 권한 체크 (내 일정만 선택 가능)
                        if (viewModel.deleteMode) {
                          final bool isMySchedule =
                              item.calendarId == viewModel.calendar?.id;
                          if (isMySchedule) {
                            viewModel.toggleSelected(item.id.toString());
                          }
                          return;
                        }

                        // 2. 상세 페이지 이동 시 권한 체크 로직
                        bool canEdit = false;

                        if (viewModel.calendar?.type == "personal") {
                          // 내 캘린더 탭: 내 고유 일정만 수정 가능
                          canEdit = item.calendarId == viewModel.calendar?.id;
                        } else {
                          // 공유 캘린더 탭: 내가 방장이고 + 현재 탭의 일정인 경우만 수정 가능
                          final isTabAdmin =
                              viewModel.calendar?.userId ==
                              viewModel.currentUserId;
                          final isCurrentTabSchedule =
                              item.calendarId == viewModel.calendar?.id;
                          canEdit = isTabAdmin && isCurrentTabSchedule;
                        }

                        // 다이얼로그 닫기
                        context.pop();

                        // 상세 페이지 이동 (isAdmin에 계산된 canEdit 전달)
                        final is_google_schedule = viewModel.displaySchedules
                            .where((s) => s.containsDay(day))
                            .any((s) => s.title.contains("[구글]"));
                        final bool? isDeleted = (!is_google_schedule)
                            ? await context.push<bool>(
                                "/schedule/detail",
                                extra: {"schedule": item, "isAdmin": canEdit},
                              )
                            : null;

                        if (isDeleted == true) {
                          await viewModel.fetchSchedules();
                        }
                      },
                      // 삭제 모드일 때 내 일정이 아니면 투명도를 주어 시각적으로 구분 (선택 사항)
                      child: Opacity(
                        opacity:
                            viewModel.deleteMode &&
                                (item.calendarId != viewModel.calendar?.id)
                            ? 0.5
                            : 1.0,
                        child: SchedulePreviewCard(item: item),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
