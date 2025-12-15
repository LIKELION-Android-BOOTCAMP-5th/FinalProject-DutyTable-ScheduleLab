import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/data/models/calendar_member_model.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/calendar_edit_body.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/custom_calendar_edit_text_field.dart';
import 'package:dutytable/features/calendar/presentation/views/edit/widgets/edit_button_section.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:dutytable/core/widgets/custom_calendar_setting_content_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CalendarEditScreen extends StatelessWidget {
  /// 캘린더 데이터
  final CalendarModel? calendar;

  /// 캘린더 수정 화면(provider 주입)
  const CalendarEditScreen({super.key, this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 캘린더 수정 뷰모델 주입
      create: (context) =>
          // 캘린더 데이터 함께 주입
          CalendarEditViewModel(initialCalendarData: calendar),
      child: _CalendarEditScreen(),
    );
  }
}

class _CalendarEditScreen extends StatelessWidget {
  /// 캘린더 수정 화면(private)
  const _CalendarEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 캘린더 수정 뷰모델 주입
    return Scaffold(
      appBar: BackActionsAppBar(
        title: Text(
          "캘린더 수정",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
        ),
      ),
      body: CalendarEditBody(),
      bottomNavigationBar: EditButtonSection(),
    );
  }
}
