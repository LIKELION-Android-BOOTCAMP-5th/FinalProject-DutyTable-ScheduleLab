import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/back_actions_app_bar.dart';
import '../../../../core/widgets/custom_confirm_dialog.dart';
import '../../data/models/calendar_model.dart';
import '../widgets/chat_tab.dart';
import 'calendar_setting_screen.dart';

class CalendarEditScreen extends StatelessWidget {
  /// 캘린더 데이터
  final CalendarModel? initialCalendarData;

  /// 캘린더 수정 화면(provider 주입)
  const CalendarEditScreen({super.key, this.initialCalendarData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 캘린더 수정 뷰모델 주입
      create: (context) =>
          // 캘린더 데이터 함께 주입
          CalendarEditViewModel(initialCalendarData: initialCalendarData),
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
                    CustomCalendarEditTextField(
                      title: const Text(
                        "캘린더 이름",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      controller: viewModel.titleController,
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
                            // 공유 캘린더일 때
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
                                              content: "방장 권한을 넘기시겠습니까?",
                                              color: Colors.blue,
                                              onConfirm: () => print("확인"),
                                            );
                                            print("권한");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
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
                                                  "권한",
                                                  style: TextStyle(
                                                    color: Colors.blue,
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
                    // 커스텀 캘린더 수정 텍스트 필드 사용
                    CustomCalendarEditTextField(
                      title: const Text(
                        "캘린더 설명",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      controller: viewModel.descController,
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
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showCustomConfirmationDialog(
                      context,
                      content: "수정 완료하시겠습니까?",
                      onConfirm: () {
                        print("확인 눌림");
                        context.pop();
                      },
                      color: Colors.blue,
                    );
                  },
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
          ),
        );
      },
    );
  }
}

class CustomCalendarEditTextField extends StatelessWidget {
  /// 박스 위에 표시할 내용
  final Widget title;
  final TextEditingController controller;

  /// 커스텀 캘린더 수정 텍스트 필드
  const CustomCalendarEditTextField({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 8),
        TextField(
          minLines: 1,
          maxLines: null, // 높이 제한 없음
          controller: controller,
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
