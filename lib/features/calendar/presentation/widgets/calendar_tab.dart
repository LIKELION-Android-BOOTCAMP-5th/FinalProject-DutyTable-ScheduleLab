import 'package:dutytable/extensions.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/widgets/custom_floatingactionbutton.dart';
import '../../../schedule/models/schedule_model.dart';
import '../../../schedule/presentation/viewmodels/schedule_view_model.dart';

class CalendarTab extends StatelessWidget {
  final CalendarModel? calendar;

  const CalendarTab({super.key, required this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleViewModel(calendar: calendar),
      child: const _CalendarTab(),
    );
  }
}

class _CalendarTab extends StatelessWidget {
  const _CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleViewModel>(
      builder: (context, viewModel, child) {
        final appointments = viewModel.schedules.map((s) {
          return Appointment(
            startTime: s.startedAt,
            endTime: s.endedAt,
            subject: s.title,
            color: Color(int.parse(s.colorValue)),
            notes: s.emotionTag,
          );
        }).toList();

        final dataSource = _ScheduleDataSource(appointments);

        return Scaffold(
          body: SfCalendar(
            view: CalendarView.month,
            dataSource: dataSource,
            headerDateFormat: 'yyyy년 MM월',
            headerStyle: CalendarHeaderStyle(
              textAlign: TextAlign.center,
              backgroundColor: AppColors.background(context),
              textStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.text(context),
              ),
            ),
            todayHighlightColor: AppColors.commonBlue,
            // 날짜 클릭 이벤트
            onTap: (details) {
              if (details.date == null) return;

              DateTime tappedDay = details.date!;

              viewModel.changeSelectedDay(tappedDay);

              // 일정이 있으면 다이얼로그 띄우기
              final hasSchedule = viewModel.schedules.any(
                (s) => s.containsDay(tappedDay),
              );

              if (hasSchedule) {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return ChangeNotifierProvider.value(
                      value: context.read<ScheduleViewModel>(),
                      child: Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: _ScheduleDialogContent(day: tappedDay),
                      ),
                    );
                  },
                );
              }
            },

            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
          ),

          floatingActionButton: const CustomFloatingActionButton(),
        );
      },
    );
  }
}

/// Syncfusion Calendar DataSource
class _ScheduleDataSource extends CalendarDataSource {
  _ScheduleDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _ScheduleDialogContent extends StatelessWidget {
  final DateTime day;

  const _ScheduleDialogContent({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleViewModel>(
      builder: (context, viewModel, _) {
        final items = viewModel.schedules
            .where((s) => s.containsDay(day))
            .toList();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단 날짜 영역
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.text(context),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          day.weekday.koreanWeekday,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.text(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap:
                          viewModel.calendar?.user_id == viewModel.currentUserId
                          ? () async {
                              if (viewModel.deleteMode) {
                                await viewModel.deleteAllSchedules();
                                await viewModel.fetchSchedules();
                                context.pop();
                              } else {
                                viewModel.toggleDeleteMode();
                              }
                            }
                          : null,
                      child:
                          viewModel.calendar?.user_id == viewModel.currentUserId
                          ? Text(
                              viewModel.deleteMode ? "삭제" : "선택삭제",
                              style: TextStyle(
                                fontSize: 14,
                                color: viewModel.deleteMode
                                    ? AppColors.commonRed
                                    : AppColors.commonBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              const SizedBox(height: 10),

              // 일정 리스트
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];

                  return GestureDetector(
                    onTap: () {
                      if (viewModel.deleteMode) {
                        viewModel.toggleSelected(item.id.toString());
                        return;
                      }

                      final isAdmin =
                          viewModel.calendar?.user_id ==
                          viewModel.currentUserId;

                      context.pop();
                      context.push(
                        "/schedule/detail",
                        extra: {"schedule": item, "isAdmin": isAdmin},
                      );
                    },
                    child: _SchedulePreviewCard(
                      item: item,
                      viewModel: viewModel,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _SchedulePreviewCard extends StatelessWidget {
  final ScheduleModel item;
  final ScheduleViewModel viewModel;

  const _SchedulePreviewCard({
    super.key,
    required this.item,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = viewModel.isSelected(item.id.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(int.parse(item.colorValue)).withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: viewModel.deleteMode && isSelected
              ? Border.all(color: AppColors.commonRed, width: 1)
              : null,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 이모지
              Text(
                item.emotionTag ?? "🙂",
                style: const TextStyle(fontSize: 28),
              ),

              const SizedBox(width: 12),

              // 세로 막대 (높이는 텍스트 높이에 자동 맞춤)
              Container(width: 6, color: Color(int.parse(item.colorValue))),

              const SizedBox(width: 12),

              // 텍스트 묶음
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 일정 제목
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // 캘린더 타입 표시
                    Text(
                      viewModel.calendar?.type == "group" ? "공유 캘린더" : "내 캘린더",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(int.parse(item.colorValue)),
                      ),
                    ),
                  ],
                ),
              ),

              if (viewModel.deleteMode)
                Checkbox(
                  value: viewModel.isSelected(item.id.toString()),
                  onChanged: (_) {
                    viewModel.toggleSelected(item.id.toString());
                  },
                  activeColor: AppColors.commonRed,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
