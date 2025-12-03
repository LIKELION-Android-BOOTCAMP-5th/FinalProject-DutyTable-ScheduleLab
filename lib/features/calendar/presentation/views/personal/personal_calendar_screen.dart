import 'package:dutytable/features/calendar/presentation/widgets/calendar_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/chat_tab.dart';
import 'package:dutytable/features/calendar/presentation/widgets/list_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/personal_calendar_view_model.dart';
import '../../widgets/custom_calendar_appbar.dart';
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
  /// 개인 캘린더 화면(local)
  const _PersonalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 개인 캘린더 뷰모델 주입
    return Consumer<PersonalCalendarViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          // 커스텀 캘린더 앱바 사용
          appBar: CustomCalendarAppbar(),
          body: SafeArea(
            // 커스텀 캘린더 탭뷰 사용
            child: CustomCalendarTabView(
              // 탭 갯수
              tabLength: viewModel.tabLength,
              // 각 탭의 이름 리스트
              tabNameList: viewModel.tabNames
                  .map((e) => Tab(child: Text(e)))
                  .toList(),
              // 각 탭 눌렀을 때 실행 할 함수
              onTap: viewModel.onTabChanged,
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
