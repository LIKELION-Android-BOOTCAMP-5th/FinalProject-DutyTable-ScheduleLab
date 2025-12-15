import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/custom_floatingactionbutton.dart';
import 'package:dutytable/extensions.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/calender_tab/calendar_tab_body.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarTab extends StatelessWidget {
  final CalendarModel? calendar;

  const CalendarTab({super.key, required this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleViewModel(calendar: calendar),
      child: const CalendarTabBody(),
    );
  }
}
