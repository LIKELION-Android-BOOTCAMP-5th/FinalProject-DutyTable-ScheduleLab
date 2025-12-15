import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_add_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/add/widgets/calendar_add_body.dart';
import 'package:dutytable/features/calendar/presentation/views/add/widgets/save_button_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarAddScreen extends StatelessWidget {
  const CalendarAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarAddViewModel(),
      child: const _CalendarAddScreen(),
    );
  }
}

class _CalendarAddScreen extends StatelessWidget {
  const _CalendarAddScreen({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackActionsAppBar(
        title: Text(
          "새 캘린더",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: CalendarAddBody(formKey: _formKey),

      bottomNavigationBar: SaveButtonSection(formKey: _formKey),
    );
  }
}
