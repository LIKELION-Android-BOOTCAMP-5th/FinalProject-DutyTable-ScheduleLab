import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/schedule_button_section.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/schedule_detail_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleDetailScreen extends StatelessWidget {
  final ScheduleModel scheduleDetail;
  final bool isAdmin;

  const ScheduleDetailScreen({
    super.key,
    required this.scheduleDetail,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleDetailViewModel(
        scheduleDetail: scheduleDetail,
        isAdmin: isAdmin,
      ),
      child: _ScheduleDetailScreen(),
    );
  }
}

class _ScheduleDetailScreen extends StatelessWidget {
  const _ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    return Scaffold(
      appBar: BackActionsAppBar(title: Text(viewModel.title)),
      body: ScheduleDetailBody(),
      bottomNavigationBar: ScheduleButtonSection(),
    );
  }
}
