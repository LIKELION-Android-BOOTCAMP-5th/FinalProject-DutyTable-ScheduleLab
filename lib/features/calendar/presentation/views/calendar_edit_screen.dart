import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/back_actions_app_bar.dart';
import '../widgets/chat_tab.dart';
import 'calendar_setting_screen.dart';

class CalendarEditScreen extends StatelessWidget {
  /// 캘린더 수정 화면(provider 주입)
  const CalendarEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 캘린더 수정 뷰모델 주입
      create: (context) => CalendarEditViewModel(),
      child: _CalendarEditScreen(),
    );
  }
}

class _CalendarEditScreen extends StatelessWidget {
  /// 캘린더 수정 화면(private)
  const _CalendarEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 캘린더 수정 뷰모델 주입
    return Consumer<CalendarEditViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: BackActionsAppBar(
            title: Text(
              "캘린더 수정",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
            ),
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
                    // 커스텀 캘린더 수정 텍스트 필드 사용
                    CustomCalendarEditTextField(
                      title: const Text(
                        "캘린더 이름",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                    // 커스텀 캘린더 수정 텍스트 필드 사용
                    CustomCalendarEditTextField(
                      title: const Text(
                        "캘린더 설명",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
                right: 8.0,
                left: 8.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
                child: BottomAppBar(
                  color: Colors.blue,
                  height: 52,
                  child: Center(
                    child: Text(
                      "수정 완료",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomCalendarEditTextField extends StatelessWidget {
  /// 박스 위에 표시할 내용
  final Widget title;

  /// 커스텀 캘린더 수정 텍스트 필드
  const CustomCalendarEditTextField({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        // Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          minLines: 1,
          maxLines: null, // 높이 제한 없음
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0x61000000)),
            ),
          ),
        ),
      ],
    );
  }
}
