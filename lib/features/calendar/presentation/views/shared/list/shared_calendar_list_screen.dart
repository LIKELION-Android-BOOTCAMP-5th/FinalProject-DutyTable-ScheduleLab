import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/logo_actions_app_bar.dart';
import 'package:dutytable/features/calendar/presentation/views/shared/list/widgets/left_actions.dart';
import 'package:dutytable/features/calendar/presentation/views/shared/list/widgets/right_actions.dart';
import 'package:dutytable/features/calendar/presentation/views/shared/list/widgets/shared_calendar_body.dart';
import 'package:flutter/material.dart';

class SharedCalendarListScreen extends StatelessWidget {
  const SharedCalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SharedCalendarListScreen();
  }
}

class _SharedCalendarListScreen extends StatelessWidget {
  /// 공유 캘린더 목록 리스트 화면
  const _SharedCalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: LogoActionsAppBar(
        leftActions: const LeftActions(),
        rightActions: const RightActions(),
      ),
      body: SafeArea(child: SharedCalendarBody()),
    );
  }
}
