import 'package:dutytable/core/configs/app_theme.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_add_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/add/schedule_add_body.dart';
import 'package:dutytable/features/schedule/presentation/views/add/schedule_add_button_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/location_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/color_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/done_status_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/emotion_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/memo_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/repeat_option_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/repeat_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/start_and_end_date_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/start_and_end_time_section.dart';
import 'package:dutytable/features/schedule/presentation/views/add/widgets/title_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/configs/app_colors.dart';

class ScheduleAddScreen extends StatelessWidget {
  const ScheduleAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleAddViewModel(),
      child: _ScheduleAddScreen(),
    );
  }
}

class _ScheduleAddScreen extends StatelessWidget {
  const _ScheduleAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: BackActionsAppBar(
        title: Text(
          "일정 추가",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
        ),
      ),

      body: ScheduleAddBody(formKey: _formKey),
      bottomNavigationBar: ScheduleAddButtonSection(formKey: _formKey),
    );
  }
}
