import 'package:dutytable/features/calendar/presentation/widgets/calendar_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/list_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/logo_actions_app_bar.dart';
import '../../viewmodels/personal_calendar_view_model.dart';
import '../../widgets/custom_calendar_tabview.dart';

class PersonalCalendarScreen extends StatelessWidget {
  /// 개인 캘린더 화면(provider 주입)
  const PersonalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 개인 캘린더 뷰모델 주입
    return ChangeNotifierProvider(
      create: (context) => PersonalCalendarViewModel(),
      child: _PersonalCalendarScreen(),
    );
  }
}

class _PersonalCalendarScreen extends StatelessWidget {
  /// 개인 캘린더 화면(private)
  const _PersonalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 개인 캘린더 뷰모델 주입
    return Consumer<PersonalCalendarViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: LogoActionsAppBar(
            rightActions: Row(
              children: [
                // 커스텀 캘린더 앱바 아이콘 사용
                CustomAppBarIcon(
                  icon: Icons.notifications,
                  onTap: () => context.push("/notification"),
                ),
                // 커스텀 캘린더 앱바 아이콘 사용
                CustomAppBarIcon(
                  icon: Icons.menu,
                  onTap: () => context.push(
                    "/calendar/setting",
                    // 캘린더 데이터 함께 보냄
                    extra: viewModel.calendarResponse,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            // 커스텀 캘린더 탭뷰 사용
            child: CustomCalendarTabView(
              // 탭 갯수
              tabLength: viewModel.tabLength,
              // 각 탭의 이름 리스트
              tabNameList: viewModel.tabNames
                  .map((e) => Tab(child: Text(e)))
                  .toList(),
              // 각 탭에 들어갈 위젯 리스트
              tabViewWidgetList: [
                // 캘린더 탭
                CalendarTab(),
                // 리스트 탭
                ListTab(),
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
