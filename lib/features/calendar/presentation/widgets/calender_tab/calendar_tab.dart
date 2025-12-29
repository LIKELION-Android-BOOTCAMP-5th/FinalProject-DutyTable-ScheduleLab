import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_floating_action_button.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/calender_tab/my_schedule_check_box.dart';
import 'package:dutytable/features/calendar/presentation/widgets/calender_tab/sf_calendar_section.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarTab extends StatelessWidget {
  final CalendarModel? calendar;

  const CalendarTab({super.key, required this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleViewModel(calendar: calendar),
      child: _CalendarTab(),
    );
  }
}

class _CalendarTab extends StatelessWidget {
  const _CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: AppColors.background(context),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              /// 내 일정 불러오기
              MyScheduleCheckBox(viewModel: viewModel),

              /// 캘린더 메인 세션
              SfCalendarSection(viewModel: viewModel),
            ],
          ),
          floatingActionButton:
              viewModel.calendar?.userId == viewModel.currentUserId
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
