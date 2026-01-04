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
                        if (viewModel.deleteMode) {
                          viewModel.toggleSelected(item.id.toString());
                          return;
                        }
                        final isAdmin =
                            viewModel.calendar?.userId ==
                            viewModel.currentUserId;

                        context.pop();

                        final bool? isDeleted = await context.push<bool>(
                          "/schedule/detail",
                          extra: {"schedule": item, "isAdmin": isAdmin},
                        );

                        if (isDeleted == true) {
                          await viewModel.fetchSchedules();
                        }
                      },
                      child: SchedulePreviewCard(item: item),
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
