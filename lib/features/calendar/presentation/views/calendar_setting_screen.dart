import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_setting_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_confirm_dialog.dart';
import '../../data/models/calendar_model.dart';
import '../widgets/chat_tab.dart';

class CalendarSettingScreen extends StatelessWidget {
  final CalendarModel? initialCalendarData;

  /// 캘린더 설정 화면(provider 주입)
  const CalendarSettingScreen({super.key, this.initialCalendarData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 캘린더 설정 뷰모델 주입
      create: (context) =>
          CalendarSettingViewModel(initialCalendarData: initialCalendarData),
      child: _CalendarSettingScreen(),
    );
  }
}

class _CalendarSettingScreen extends StatelessWidget {
  /// 캘린더 설정 화면(private)
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
                  context.push(
                    "/calendar/edit",
                    extra: viewModel.calendarResponse,
                  );
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
                    CustomCalendarSettingContentBox(
                      title: const Text(
                        "캘린더 이름",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(viewModel.calendarResponse.title),
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
                          // 멤버 목록이 비었을 경우(개인 캘린더의 경우) 방장만 표시하기위해 1을 반환
                          itemCount:
                              viewModel
                                      .calendarResponse
                                      .calendarMemberModel
                                      ?.isEmpty ??
                                  true
                              ? 1
                              : viewModel
                                    .calendarResponse
                                    .calendarMemberModel!
                                    .length,
                          itemBuilder: (context, index) {
                            final members =
                                viewModel.calendarResponse.calendarMemberModel;
                            // 개인 캘린더일 때(멤버 목록이 없을 때)
                            if (members == null || members.isEmpty) {
                              return CustomCalendarSettingContentBox(
                                title: null,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const CustomChatProfileImageBox(
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          viewModel
                                              .calendarResponse
                                              .ownerNickname,
                                        ),
                                        const Text("👑"), // 방장 표시
                                      ],
                                    ),
                                    const SizedBox.shrink(),
                                  ],
                                ),
                              );
                            }

                            final member = members[index];

                            return CustomCalendarSettingContentBox(
                              title: null,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // 커스텀 프로필 이미지 박스 사용
                                      CustomChatProfileImageBox(
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(width: 4),
                                      // 멤버 닉네임
                                      Text(member.nickname),
                                    ],
                                  ),
                                  // 개인 캘린더는 추방 버튼 안나옴
                                  viewModel.calendarResponse.type == "personal"
                                      ? SizedBox.shrink()
                                      // 공유 캘린더는 방장만 추방 버튼 안나옴
                                      : viewModel
                                            .calendarResponse
                                            .calendarMemberModel![index]
                                            .is_admin
                                      // 방장 표시
                                      ? const Text("👑")
                                      // 추방 버튼
                                      : GestureDetector(
                                          // 전체 영역 터치 가능
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            showCustomConfirmationDialog(
                                              context,
                                              content: "추방하시겠습니까?",
                                              color: Colors.red,
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
                    CustomCalendarSettingContentBox(
                      title: const Text(
                        "캘린더 설명",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text(viewModel.calendarResponse.description ?? ""),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 공유 캘린더만 표시
          bottomNavigationBar: viewModel.calendarResponse.type == "personal"
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                      right: 8.0,
                      left: 8.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(12),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showCustomConfirmationDialog(
                            context,
                            content: "캘린더를 삭제하시겠습니까?",
                            color: Colors.red,
                            onConfirm: () {
                              print("확인 눌림");
                            },
                          );
                        },
                        child: BottomAppBar(
                          color: Colors.red,
                          height: 52,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline, color: Colors.white),
                              Text(
                                "캘린더 삭제",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
