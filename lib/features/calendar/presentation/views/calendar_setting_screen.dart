import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_tab.dart';

class CalendarSettingScreen extends StatelessWidget {
  /// 캘린더 설정 화면(provider 주입)
  const CalendarSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 캘린더 설정 뷰모델 주입
      create: (context) => CalendarSettingViewModel(),
      child: _CalendarSettingScreen(),
    );
  }
}

class _CalendarSettingScreen extends StatelessWidget {
  /// 캘린더 설정 화면(local)
  const _CalendarSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 캘린더 설정 뷰모델 주입
    return Consumer<CalendarSettingViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: BackActionsAppBar(
            title: Text(
              "캘린더 설정",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
            ),
            actions: [
              // 리플 없는 버튼
              GestureDetector(
                onTap: () {
                  print("수정 버튼 눌림");
                },
                child: const Text(
                  "수정",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // 위젯 크기와 수에 따른 전체 영역 스크롤
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 캘린더 이름
                    // 커스텀 캘린더 설정 컨텐츠 박스 사용
                    CustomCalendarSettingContentBox(
                      title: const Text(
                        "캘린더 이름",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(viewModel.calendarName),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // 캘린더 멤버 목록
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "캘린더 멤버",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.calendarMember.length,
                          itemBuilder: (context, index) {
                            // 방장 표시
                            final List<Widget> adminWidgets =
                                viewModel.isAdmin[index]
                                ? [
                                    const Text("👑"),
                                    const SizedBox(width: 4),
                                    const Text("방장"),
                                    const SizedBox(width: 4),
                                  ]
                                : [];

                            return CustomCalendarSettingContentBox(
                              title: null,
                              child: Row(
                                children: [
                                  // 방장 표시
                                  ...adminWidgets,
                                  // 커스텀 프로필 이미지 박스 사용
                                  CustomChatProfileImageBox(
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  // 멤버 닉네임
                                  Text(viewModel.calendarMember[index]),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 8); // 멤버간 간격
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // 캘린더 설명
                    // 커스텀 캘린더 설정 컨텐츠 박스 사용
                    CustomCalendarSettingContentBox(
                      title: const Text(
                        "캘린더 설명",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text(viewModel.calendarDescription),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomCalendarSettingContentBox extends StatelessWidget {
  /// 박스 위에 표시할 내용
  final Widget? title;

  /// 박스 안에 표시할 내용
  final Widget child;

  /// 커스텀 캘린더 설정 컨텐츠 박스
  const CustomCalendarSettingContentBox({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // 반환할 위젯 리스트
    List<Widget> childrenList = [];

    // 박스 위에 표시할 내용 없을 경우
    if (title != null) {
      childrenList.add(title!);
      childrenList.add(const SizedBox(height: 8));
    }

    // 박스 위에 표시할 내용 있을 경우
    childrenList.add(
      ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 52.0, // 기본 최소 높이
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x61000000)),
            color: const Color(0x10000000),
          ),
          child: child,
        ),
      ),
    );

    // 실제 리턴 부분
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: childrenList,
    );
  }
}

class CustomCalendarEditDescriptionBox extends StatelessWidget {
  final String title;
  final double height;
  final String content;
  const CustomCalendarEditDescriptionBox({
    super.key,
    required this.title,
    this.height = 60,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // 중요: 내용물 크기에 맞게 Column의 크기를 최소화
            children: [
              Container(
                width: double.maxFinite,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(color: Color(0x61000000)),
                  color: Color(0x10000000),
                ),
                child: Text(content),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
