import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/logo_actions_app_bar.dart';
import '../../widgets/calendar_card.dart';

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
    // 로딩, 에러, 성공 상태에 따른 분기 처리
    Widget bodyContent;

    switch (viewModel.state) {
      case ViewState.loading:
        // 데이터 로드 중일 때 로딩 인디케이터 표시
        bodyContent = const Center(child: CircularProgressIndicator());
        break;

      case ViewState.error:
        // 오류 발생 시 에러 메시지 표시
        bodyContent = Center(
          child: Text(
            "데이터 로드 실패: ${viewModel.errorMessage ?? '알 수 없는 오류'}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        );
        break;

      case ViewState.success:
        // 로드 성공 시 ListView 표시
        final calendars = viewModel.calendarResponse;

        if (calendars == null || calendars.isEmpty) {
          // 데이터가 비어있을 경우
          bodyContent = const Center(child: Text("공유 캘린더가 없습니다."));
        } else {
          // 데이터가 있을 경우 ListView 출력
          bodyContent = ListView.separated(
            itemCount: calendars.length,
            itemBuilder: (BuildContext context, int index) {
              final calendar = calendars[index];
              return CalendarCard(
                title: calendar.title,
                deleteMode: viewModel.deleteMode,
                isAdmin:
                    viewModel.calendarResponse?[index].user_id ==
                    viewModel.currentUserId,
                members: calendar.calendarMemberModel?.length ?? 0,
                isSelected: viewModel.isSelected(calendar.id.toString()),
                onChangeSelected: () =>
                    viewModel.toggleSelected(calendar.id.toString()),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 12);
            },
          );
        }
        break;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: LogoActionsAppBar(
        leftActions: const _LeftActions(),
        rightActions: const _RightActions(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: bodyContent,
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
                decoration: BoxDecoration(
                  color: AppColors.commonBlue,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () => context.push("/shared/add"),
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
