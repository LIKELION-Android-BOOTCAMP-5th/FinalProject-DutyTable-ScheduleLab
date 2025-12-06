import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/logo_actions_app_bar.dart';
import '../../widgets/calendar_card.dart';

/// TODO
/// 캘린더 목록 API 연결 시 하드코딩 삭제 필요
class SharedCalendarListScreen extends StatelessWidget {
  const SharedCalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SharedCalendarViewModel(),
      child: _SharedCalendarListScreen(),
    );
  }
}

class _SharedCalendarListScreen extends StatelessWidget {
  const _SharedCalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SharedCalendarViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: LogoActionsAppBar(
        leftActions: _LeftActions(),
        rightActions: _RightActions(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            CalendarCard(
              title: "팀 프로젝트",
              deleteMode: viewModel.deleteMode,
              isAdmin: viewModel.isAdmin,
              isSelected: viewModel.isSelected("team_project_1"),
              onChangeSelected: () =>
                  viewModel.toggleSelected("team_project_1"),
            ),

            const SizedBox(height: 12),

            CalendarCard(
              title: "부서 공지",
              deleteMode: viewModel.deleteMode,
              isAdmin: !viewModel.isAdmin,
              isSelected: viewModel.isSelected("dept_notice"),
              onChangeSelected: () => viewModel.toggleSelected("dept_notice"),
            ),

            const SizedBox(height: 12),

            CalendarCard(
              title: "운동",
              deleteMode: viewModel.deleteMode,
              isAdmin: viewModel.isAdmin,
              isSelected: viewModel.isSelected("exercise"),
              onChangeSelected: () => viewModel.toggleSelected("exercise"),
            ),
          ],
        ),
      ),
    );
  }
}

/// 앱바 - 왼쪽 로고 + 타이틀
class _LeftActions extends StatelessWidget {
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
        const Text(
          "DutyTable",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/// 앱바 - 오른쪽 아이콘 모음들
class _RightActions extends StatelessWidget {
  const _RightActions({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SharedCalendarViewModel>();

    return viewModel.deleteMode
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => viewModel.cancelDeleteMode(),
                child: Text("취소"),
              ),
              const SizedBox(width: 16),
              Text("삭제"),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF3A7BFF),
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () => context.push("/shared/add"),
                  child: Icon(Icons.add, color: Colors.white),
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
                        decoration: const BoxDecoration(
                          color: Colors.red,
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
