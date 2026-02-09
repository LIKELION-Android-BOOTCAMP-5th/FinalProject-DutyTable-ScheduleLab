import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../schedule_dialog/schedule_dialog.dart';

/// 캘린더 메인 세션
class SfCalendarSection extends StatelessWidget {
  final ScheduleViewModel viewModel;

  const SfCalendarSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final dataSource = CalendarTabScheduleDataSource.fromSchedules(
      viewModel.displaySchedules,
    );

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSpaceTooSmall = constraints.maxHeight < 350;

          return SfCalendar(
            dataSource: dataSource,
            view: CalendarView.month,
            headerDateFormat: 'yyyy년 MM월',
            backgroundColor: AppColors.background(context),
            todayTextStyle: TextStyle(color: AppColors.pureWhite),
            todayHighlightColor: AppColors.primaryBlue,
            selectionDecoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryBlue, width: 2),
            ),
            headerStyle: _headerStyle(context),
            viewHeaderStyle: _viewHeaderStyle(context),
            monthViewSettings: _monthViewSettings(context, isSpaceTooSmall),
            onTap: (details) => _handleCalendarTap(context, details),
          );
        },
      ),
    );
  }

  CalendarHeaderStyle _headerStyle(BuildContext context) {
    return CalendarHeaderStyle(
      textAlign: TextAlign.center,
      backgroundColor: AppColors.background(context),
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.textMain(context),
      ),
    );
  }

  ViewHeaderStyle _viewHeaderStyle(BuildContext context) {
    return ViewHeaderStyle(
      dayTextStyle: TextStyle(
        color: AppColors.textMain(context),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  MonthViewSettings _monthViewSettings(
    BuildContext context,
    bool isSpaceTooSmall,
  ) {
    return MonthViewSettings(
      appointmentDisplayMode: isSpaceTooSmall
          ? MonthAppointmentDisplayMode.indicator
          : MonthAppointmentDisplayMode.appointment,

      appointmentDisplayCount: 2,

      monthCellStyle: MonthCellStyle(
        textStyle: TextStyle(color: AppColors.textMain(context)),
        trailingDatesTextStyle: TextStyle(color: AppColors.textSub(context)),
        leadingDatesTextStyle: TextStyle(color: AppColors.textSub(context)),
      ),
    );
  }

  void _handleCalendarTap(
    BuildContext context,
    CalendarTapDetails details,
  ) async {
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
  }
}

/// 일정 - 데이터 소스
class CalendarTabScheduleDataSource extends CalendarDataSource {
  CalendarTabScheduleDataSource(List<Appointment> source) {
    appointments = source;
  }

  factory CalendarTabScheduleDataSource.fromSchedules(
    List<ScheduleEntity> schedules,
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
