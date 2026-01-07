import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/presentation/viewmodels/schedule_detail_view_model.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/schedule_detail_body.dart';
import 'package:dutytable/features/schedule/presentation/views/detail/schedule_detail_button_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        scheduleId: scheduleDetail.id,
        isAdmin: isAdmin,
      ),
      child: const _ScheduleDetailScreen(),
    );
  }
}

class _ScheduleDetailScreen extends StatelessWidget {
  const _ScheduleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ScheduleDetailViewModel>();

    /// 일정 디테일 - 삭제된 상태
    if (viewModel.state == DetailViewState.deleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && context.canPop()) {
          context.pop(true);
        }
      });

      return Scaffold(
        backgroundColor: AppColors.background(context),
        body: const SizedBox.shrink(),
      );
    }

    /// 일정 디테일 - 로딩중인 상태
    if (viewModel.state == DetailViewState.loading) {
      return Scaffold(
        backgroundColor: AppColors.background(context),
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary(context),
            strokeWidth: 2,
          ),
        ),
      );
    }

    /// 일정 디테일 - 에러인 상태
    if (viewModel.state == DetailViewState.error || !viewModel.hasData) {
      return Scaffold(
        backgroundColor: AppColors.background(context),
        body: Center(
          child: Text(
            '일정을 불러오지 못했습니다',
            style: TextStyle(color: AppColors.textMain(context)),
          ),
        ),
      );
    }

    /// 일정 디테일 - 성공인 상태
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: BackActionsAppBar(
        title: Text(
          viewModel.title,
          style: TextStyle(color: AppColors.textMain(context)),
        ),
      ),
      body: const ScheduleDetailBody(),
      bottomNavigationBar: const ScheduleDetailButtonSection(),
    );
  }
}
