import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_edit_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/edit/schedule_detail_edit_body.dart';
import 'package:dutytable/features/schedule/presentation/views/edit/schedule_detail_edit_button_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleDetailEditScreen extends StatelessWidget {
  final ScheduleModel scheduleDetail;
  final bool isAdmin;

  const ScheduleDetailEditScreen({
    super.key,
    required this.scheduleDetail,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ScheduleDetailViewModel(
            scheduleId: scheduleDetail.id,
            isAdmin: isAdmin,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ScheduleEditViewModel(schedule: scheduleDetail),
        ),
      ],
      child: _ScheduleDetailEditScreen(),
    );
  }
}

class _ScheduleDetailEditScreen extends StatelessWidget {
  const _ScheduleDetailEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: BackActionsAppBar(
        title: Text(
          viewModel.title,
          style: TextStyle(color: AppColors.textMain(context)),
        ),
      ),
      body: const ScheduleDetailEditBody(),
      bottomNavigationBar: const ScheduleDetailEditButtonSection(),
    );
  }
}
