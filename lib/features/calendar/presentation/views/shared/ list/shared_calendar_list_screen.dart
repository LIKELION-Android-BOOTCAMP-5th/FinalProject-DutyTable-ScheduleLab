import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/logo_actions_app_bar.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/shared/%20list/widgets/shared_calendar_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SharedCalendarListScreen extends StatelessWidget {
  final List<CalendarModel>? initialCalendars;

  const SharedCalendarListScreen({super.key, this.initialCalendars});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SharedCalendarViewModel>();

    // build 중에 직접 실행하면 에러가 날 수 있으므로 setInitialData 내부에 microtask 처리를
    if (initialCalendars != null) {
      viewModel.setInitialData(initialCalendars);
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            color: AppColors.text(context),
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
          child: const Text("취소"),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: viewModel.deleteSelectedCalendars,
          child: const Text("삭제"),
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
            color: AppColors.commonBlue,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: () async {
              final result = await context.push<bool>("/calendar/add");

              if (result == true) {
                context.read<SharedCalendarViewModel>().fetchCalendars();
              }
            },
            child: Icon(Icons.add, color: AppColors.commonWhite),
          ),
        ),

        const SizedBox(width: 16),

        GestureDetector(
          onTap: () => context.push("/notification"),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none, size: 26),
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.commonRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        GestureDetector(
          onTap: () => viewModel.toggleDeleteMode(),
          child: const Icon(Icons.delete_outline, size: 26),
        ),
      ],
    );
  }
}
