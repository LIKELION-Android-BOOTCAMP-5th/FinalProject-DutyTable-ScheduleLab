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
          body: Column(
            children: [
              if (viewModel.calendar!.type != "personal") ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      value: viewModel.isFetchMySchedule,
                      onChanged: (_) => viewModel.toggleFetchMySchedule(),
                    ),
                    const Text("내 일정 불러오기"),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
              Expanded(
                child: SfCalendar(
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
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                  ),
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
