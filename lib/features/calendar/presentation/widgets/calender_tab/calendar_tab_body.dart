import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_floatingactionbutton.dart';
import 'package:dutytable/extensions.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'schedule_dialog/schedule_dialog.dart';

class CalendarTabBody extends StatelessWidget {
  /// 캘린더 탭 - 바디(캘린더 모양)
  const CalendarTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleViewModel>(
      builder: (context, viewModel, _) {
        final dataSource = CalendarTabScheduleDataSource.fromSchedules(
          viewModel.displaySchedules,
        );

        return Scaffold(
          backgroundColor: AppColors.background(context),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              if (viewModel.calendar!.type != "personal") ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      value: viewModel.isFetchMySchedule,
                      onChanged: (_) => viewModel.toggleFetchMySchedule(),
                      activeColor: AppColors.primaryBlue,
                      checkColor: AppColors.pureWhite,
                      side: BorderSide(color: AppColors.textSub(context)),
                    ),
                    Text(
                      "내 일정 불러오기",
                      style: TextStyle(color: AppColors.textMain(context)),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
              Expanded(
                child: SfCalendar(
                  view: CalendarView.month,
                  dataSource: dataSource,
                  headerDateFormat: 'yyyy년 MM월',
                  backgroundColor: AppColors.background(context),
                  headerStyle: CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                    backgroundColor: AppColors.background(context),
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain(context),
                    ),
                  ),
                  todayHighlightColor: AppColors.primaryBlue,
                  todayTextStyle: TextStyle(color: AppColors.pureWhite),
                  selectionDecoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryBlue, width: 2),
                  ),
                  viewHeaderStyle: ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                      color: AppColors.textMain(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                    // 날짜 숫자 텍스트 스타일
                    monthCellStyle: MonthCellStyle(
                      textStyle: TextStyle(color: AppColors.textMain(context)),
                      trailingDatesTextStyle: TextStyle(
                        color: AppColors.textSub(context),
                      ),
                      leadingDatesTextStyle: TextStyle(
                        color: AppColors.textSub(context),
                      ),
                    ),
                  ),
                  onTap: (details) async {
                    final date = details.date;
                    if (date == null) return;

                    viewModel.changeSelectedDay(date);

                    final hasSchedule = viewModel.displaySchedules.any(
                      (s) => s.containsDay(date),
                    );
                    if (!hasSchedule) return;

                    await showDialog(
                      context: context,
                      builder: (_) => ChangeNotifierProvider.value(
                        value: viewModel,
                        child: ScheduleDialog(day: date),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton:
              viewModel.calendar!.user_id == viewModel.currentUserId
              ? CustomFloatingActionButton(
                  calendarId: viewModel.calendar!.id,
                  date: viewModel.selectedDay,
                )
              : null,
        );
      },
    );
  }
}

/// 일정 - 데이터 소스
class CalendarTabScheduleDataSource extends CalendarDataSource {
  CalendarTabScheduleDataSource(List<Appointment> source) {
    appointments = source;
  }

  factory CalendarTabScheduleDataSource.fromSchedules(
    List<ScheduleModel> schedules,
  ) {
    return CalendarTabScheduleDataSource(
      schedules
          .map(
            (s) => Appointment(
              startTime: s.startedAt,
              endTime: s.endedAt,
              subject: s.title,
              color: Color(int.parse(s.colorValue)),
              notes: s.emotionTag,
            ),
          )
          .toList(),
    );
  }
}
