import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_tab.dart';

class CalendarSettingScreen extends StatelessWidget {
  const CalendarSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarSettingViewModel(),
      child: _CalendarSettingScreen(),
    );
  }
}

class _CalendarSettingScreen extends StatelessWidget {
  const _CalendarSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarSettingViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("캘린더 설정"),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () {},
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
            actionsPadding: EdgeInsets.all(16),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    // 2. 캘린더 멤버 목록
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
                            final List<Widget> adminWidgets =
                                viewModel.isAdmin[index]
                                ? [
                                    const Text("👑"),
                                    const SizedBox(width: 4),
                                    const Text("방장"),
                                    const SizedBox(width: 4),
                                  ]
                                : []; // Admin이 아니면 빈 리스트

                            return CustomCalendarSettingContentBox(
                              title: null,
                              child: Row(
                                children: [
                                  ...adminWidgets,
                                  CustomChatProfileImageBox(
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(viewModel.calendarMember[index]),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 8);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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
  final Widget? title;
  final Widget child;
  const CustomCalendarSettingContentBox({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> childrenList = [];

    if (title != null) {
      childrenList.add(title!);
      childrenList.add(const SizedBox(height: 8));
    }

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
