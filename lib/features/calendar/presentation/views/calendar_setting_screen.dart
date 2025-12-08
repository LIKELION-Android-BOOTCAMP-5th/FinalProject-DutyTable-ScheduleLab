import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                  context.push("/calendar/edit");
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                  viewModel.isAdmin[index]
                                      ? SizedBox.shrink()
                                      : GestureDetector(
                                          // 전체 영역 터치 가능
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            _showCustomConfirmationDialog(
                                              context,
                                              title: "title",
                                              content: "content",
                                              onConfirm: () => print("확인"),
                                            );
                                            print("추방");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadiusGeometry.circular(
                                                    8,
                                                  ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "추방",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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

void _showCustomConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm, // 버튼 클릭 시 실행할 함수
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // 취소 버튼
          TextButton(
            child: const Text('취소'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // 기능 실행 버튼
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              onConfirm(); // 전달받은 함수 실행
            },
          ),
        ],
      );
    },
  );
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
          minHeight: 56.0, // 기본 최소 높이(텍스트 필드랑 동일하게)
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
