import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/setting/widgets/calendar_setting_body.dart';
import 'package:dutytable/features/calendar/presentation/views/setting/widgets/delete_button_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CalendarSettingScreen extends StatelessWidget {
  final CalendarModel? calendar;

  const CalendarSettingScreen({super.key, this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarSettingViewModel(calendar: calendar),
      child: const _CalendarSettingScreen(),
    );
  }
}

class _CalendarSettingScreen extends StatelessWidget {
  const _CalendarSettingScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarSettingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: BackActionsAppBar(
        title: Text(
          "캘린더 설정",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),
        actions: viewModel.calendar.userId == viewModel.currentUser!.id
            ? [_EditButton()]
            : null,
      ),
      body: const CalendarSettingBody(),
      bottomNavigationBar: viewModel.calendar.type == "group"
          ? const DeleteButtonSection()
          : null,
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CalendarSettingViewModel>();

    return GestureDetector(
      onTap: () async {
        await context.push("/calendar/edit", extra: viewModel.calendar);
        viewModel.fetchCalendar();
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          "수정",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
