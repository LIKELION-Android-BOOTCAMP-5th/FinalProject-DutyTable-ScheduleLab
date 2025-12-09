import 'package:flutter/material.dart';

class CustomCalendarTabView extends StatelessWidget {
  /// 탭 갯수
  final int tabLength;

  /// 각 탭의 이름 리스트
  final List<Widget> tabNameList;

  /// 각 탭에 들어갈 위젯 리스트
  final List<Widget> tabViewWidgetList;

  /// 커스텀 캘린더 탭뷰
  const CustomCalendarTabView({
    super.key,
    required this.tabLength,
    required this.tabNameList,
    required this.tabViewWidgetList,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLength,
      // TabBar와 TabBarView를 나누기 위해 Scaffold 사용
      child: Scaffold(
        appBar: TabBar(tabs: tabNameList),
        body: TabBarView(children: tabViewWidgetList),
      ),
    );
  }
}
