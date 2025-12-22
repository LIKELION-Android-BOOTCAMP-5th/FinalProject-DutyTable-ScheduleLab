import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/logo_actions_app_bar.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/shared/%20list/widgets/shared_calendar_body.dart';
import 'package:dutytable/features/notification/presentation/widgets/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SharedCalendarListScreen extends StatelessWidget {
  final List<CalendarModel>? initialCalendars;

  const SharedCalendarListScreen({super.key, this.initialCalendars});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SharedCalendarViewModel>();

    if (initialCalendars != null) {
      Future.microtask(() => viewModel.setInitialData(initialCalendars!));
    }

    return const _SharedCalendarListScreen();
  }
}

class _SharedCalendarListScreen extends StatelessWidget {
  /// 공유 캘린더 목록 리스트 화면
  const _SharedCalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deleteMode = context.select<SharedCalendarViewModel, bool>(
      (viewModel) => viewModel.deleteMode,
    );

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: LogoActionsAppBar(
        leftActions: const _LeftActions(),
        rightActions: deleteMode
            ? const _DeleteModeActions()
            : const _NormalActions(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: SharedCalendarBody(),
        ),
      ),
    );
  }
}

class _LeftActions extends StatelessWidget {
  /// 공유 캘린더 목록 - 앱바 :  왼쪽 로고 + 타이틀
  const _LeftActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/calendar_logo.png",
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        ),
        const SizedBox(width: 4),
        Text(
          "DutyTable",
          style: TextStyle(
            color: AppColors.textMain(context),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DeleteModeActions extends StatelessWidget {
  /// 공유 캘린더 목록 - 앱바 : 삭제 모드
  const _DeleteModeActions({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SharedCalendarViewModel>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: viewModel.cancelDeleteMode,
          child: Text(
            "취소",
            style: TextStyle(color: AppColors.textSub(context)),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: viewModel.outSelectedCalendars,
          child: Text("삭제", style: TextStyle(color: AppColors.danger(context))),
        ),
      ],
    );
  }
}

class _NormalActions extends StatelessWidget {
  /// 공유 캘린더 목록 - 앱바 : 일반 모드
  const _NormalActions({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SharedCalendarViewModel>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: () async {
              final result = await context.push<bool>("/calendar/add");

              if (result == true) {
                context.read<SharedCalendarViewModel>().fetchCalendars();
              }
            },
            child: Icon(Icons.add, color: AppColors.pureWhite),
          ),
        ),

        const SizedBox(width: 16),
        const NotificationIcon(),
        const SizedBox(width: 16),

        GestureDetector(
          onTap: () => viewModel.toggleDeleteMode(),
          child: Icon(
            Icons.delete_outline,
            size: 26,
            color: AppColors.textMain(context),
          ),
        ),
      ],
    );
  }
}
