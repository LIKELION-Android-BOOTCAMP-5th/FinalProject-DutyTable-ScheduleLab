import 'package:dutytable/features/calendar/presentation/widgets/calender_tab/calendar_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/list_tab.dart';
import 'package:dutytable/features/notification/presentation/widgets/notification_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/logo_actions_app_bar.dart';
import '../../viewmodels/personal_calendar_view_model.dart';
import '../../widgets/custom_calendar_tabview.dart';

class PersonalCalendarScreen extends StatelessWidget {
  const PersonalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PersonalCalendarScreen();
  }
}

class _PersonalCalendarScreen extends StatelessWidget {
  /// 개인 캘린더 화면(private)
  const _PersonalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PersonalCalendarViewModel>();

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
            style: const TextStyle(color: Colors.red),
          ),
        );
        break;

      case ViewState.success:
        bodyContent = CustomCalendarTabView(
          // 탭 갯수
          tabLength: viewModel.tabLength,
          // 각 탭의 이름 리스트
          tabNameList: viewModel.tabNames.map((e) => e).toList(),
          // 각 탭에 들어갈 위젯 리스트
          tabViewWidgetList: [
            // 캘린더 탭
            CalendarTab(calendar: viewModel.calendar!),
            // 리스트 탭
            ListTab(calendar: viewModel.calendar!),
            // 채팅 탭
            ChatTab(calendar: viewModel.calendar!),
          ],
        );
        break;
    }

    return Scaffold(
      appBar: LogoActionsAppBar(
        rightActions: Row(
          children: [
            const NotificationIcon(),
            // 커스텀 캘린더 앱바 아이콘 사용
            CustomAppBarIcon(
              icon: Icons.menu,
              onTap: () async {
                await context.push(
                  "/calendar/setting",
                  // 캘린더 데이터 함께 보냄
                  extra: viewModel.calendar,
                );
                viewModel.fetchCalendar();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        // 커스텀 캘린더 탭뷰 사용
        child: bodyContent,
      ),
    );
  }
}

class CustomAppBarIcon extends StatelessWidget {
  /// 아이콘
  final IconData icon;

  /// 실행 함수
  final void Function() onTap;

  /// 커스텀 캘린더 앱바 아이콘
  const CustomAppBarIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // 리플 없는 버튼
    return GestureDetector(
      // 전체 영역 터치 가능
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 28),
      ),
    );
  }
}
