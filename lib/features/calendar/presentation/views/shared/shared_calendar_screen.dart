import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/calendar/presentation/views/personal/personal_calendar_screen.dart';
import 'package:dutytable/features/calendar/presentation/widgets/calendar_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/custom_calendar_tabview.dart';
import 'package:dutytable/features/calendar/presentation/widgets/list_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SharedCalendarScreen extends StatelessWidget {
  // 3단계 : 데이터 받기
  final CalendarModel calendar;

  const SharedCalendarScreen({super.key, required this.calendar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          SharedCalendarViewModel(calendar: calendar), // 4단계 : 뷰모델로 전달
      child: _SharedCalendarScreen(),
    );
  }
}

class _SharedCalendarScreen extends StatelessWidget {
  const _SharedCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SharedCalendarViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: BackActionsAppBar(
            title: const SizedBox.shrink(),
            actions: [
              Row(
                children: [
                  // 커스텀 캘린더 앱바 아이콘 사용
                  CustomAppBarIcon(
                    icon: Icons.notifications_none,
                    onTap: () => context.push("/notification"),
                  ),
                  // 커스텀 캘린더 앱바 아이콘 사용
                  CustomAppBarIcon(
                    icon: Icons.menu,
                    onTap: () => context.push(
                      "/calendar/setting",
                      // 캘린더 데이터 함께 보냄
                      extra: viewModel.calendarList,
                    ),
                  ),
                ],
              ),
            ],
          ),

          body: SafeArea(
            // 커스텀 캘린더 탭뷰 사용
            child: CustomCalendarTabView(
              // 탭 갯수
              tabLength: viewModel.tabLength,
              // 각 탭의 이름 리스트
              tabNameList: viewModel.tabNames.map((e) => e).toList(),
              // 각 탭에 들어갈 위젯 리스트
              tabViewWidgetList: [
                // 캘린더 탭
                CalendarTab(calendar: viewModel.calendar), // 6단계 : 데이터 전달
                // 리스트 탭
                ListTab(calendar: viewModel.calendar), // 6단계 : 데이터 전달
                // 채팅 탭
                ChatTab(),
              ],
            ),
          ),
        );
      },
    );
  }
}
