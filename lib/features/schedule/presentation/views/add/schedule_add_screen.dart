import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/di/injection.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/domain/entities/detected_schedule.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/add/schedule_add_body.dart';
import 'package:dutytable/features/schedule/presentation/views/add/schedule_add_button_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleAddScreen extends StatelessWidget {
  final int calendarId;
  final DateTime? date;
  final DetectedSchedule? detectedSchedule;

  const ScheduleAddScreen({
    super.key,
    required this.calendarId,
    this.date,
    this.detectedSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = getIt<ScheduleAddViewModel>(param1: date);
        if (detectedSchedule != null) {
          vm.prefillFromDetectedSchedule(detectedSchedule!);
        }
        return vm;
      },
      child: _ScheduleAddScreen(calendarId: calendarId),
    );
  }
}

class _ScheduleAddScreen extends StatelessWidget {
  final int calendarId;
  const _ScheduleAddScreen({required this.calendarId});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: BackActionsAppBar(
        title: Text(
          "일정 추가",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),
      ),

      body: ScheduleAddBody(formKey: formKey),
      bottomNavigationBar: ScheduleAddButtonSection(
        formKey: formKey,
        calendarId: calendarId,
      ),
    );
  }
}
