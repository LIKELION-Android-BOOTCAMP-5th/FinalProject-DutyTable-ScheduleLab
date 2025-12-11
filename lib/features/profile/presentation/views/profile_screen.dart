import 'package:dutytable/core/widgets/logo_actions_app_bar.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:dutytable/features/profile/presentation/widgets/custom_dialog.dart';
import 'package:dutytable/features/profile/presentation/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewmodel(),
      child: _ProfileScreen(),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewmodel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: LogoActionsAppBar(
            leftActions: const Text(
              "프로필",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            rightActions: GestureDetector(
              onTap: () {
                //로그아웃 다이얼로그
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    context,
                    height: 240.0,
                    iconBackgroundColor: Color(0xFFDBE9FE),
                    icon: Icons.logout_outlined,
                    iconColor: Color(0xFF3C82F6),
                    title: "로그아웃",
                    message: "정말 로그아웃 하시겠습니까?",
                    allow: "로그아웃",
                    onChangeSelected: () => {
                      viewModel.logout(),
                      context.pop(),
                      context.go('/login'),
                    },
                    onClosed: () => context.pop(),
                  ),
                );
              },
              child: Icon(Icons.logout, color: Color(0xFF545D6A)),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: SafeArea(
              child: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),

                      //프로필쪽
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Stack(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child:
                                    // image가 없거나 비어있을때
                                    (viewModel.image == null ||
                                        viewModel.image!.isEmpty)
                                    ? Icon(Icons.account_circle, size: 60)
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(100),
                                        child: Image.network(
                                          '${viewModel.image!}',
                                          width: double.infinity,
                                          height: 350,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              // 프로필 수정 버튼 누를 시
                              (viewModel.is_edit)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 30.0,
                                        top: 30,
                                      ),
                                      // 카메라 아이콘 추가
                                      child: GestureDetector(
                                        onTap: () async {
                                          await viewModel.getImage(
                                            ImageSource.gallery,
                                          );
                                          await viewModel.upload();
                                        },

                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            top: 20,
                                          ),
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          (viewModel.is_edit)
                              ? Expanded(
                                  // 닉네임 텍스트 필드
                                  child: TextField(
                                    controller: viewModel.nicknameController,
                                    decoration: InputDecoration(
                                      hintText: "닉네임을 입력해주세요",
                                      border: OutlineInputBorder(),
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  "${viewModel.nickname}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          (viewModel.is_edit)
                              // 중복체크 버튼 추가
                              ? GestureDetector(
                                  onTap: () {
                                    viewModel.nicknameOverlapping();
                                  },
                                  child: Text("   중복체크  "),
                                )
                              : Spacer(),
                          GestureDetector(
                            onTap: () async {
                              if (viewModel.is_edit == false) {
                                viewModel.setProfileEdit(); //수정으로 들어가기
                              } else {
                                viewModel
                                    .nicknameCheck(); // 닉네임 중복, 글자수 체크 후 저장
                              }
                            },
                            child: Text(
                              (viewModel.is_edit) ? "  저장  " : "수정  ",
                              style: TextStyle(
                                color: Color(0xFF3C82F6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(padding: EdgeInsets.only(right: 10)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(10)),

                      //내 계정
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFF9FAFB),
                                  ),
                                  child: SizedBox(height: 50),
                                ),
                                Column(
                                  children: [
                                    Padding(padding: EdgeInsets.all(7)),
                                    Text(
                                      "   내 계정 : ${viewModel.email}",

                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 20)),
                        ],
                      ),
                      //구글 캘린더 동기화
                      Padding(padding: EdgeInsets.all(7)),
                      CustomTab(
                        icon: Icons.settings_outlined,
                        buttonText: "  구글 캘린더 동기화",
                        padding: 7.0,
                        addWidget: GestureDetector(
                          onTap: () {
                            viewModel.googleSync();
                            viewModel.updateGoogleSync(viewModel.user!.id);
                          },
                          child: Text(
                            (viewModel.is_sync) ? "연결해제    " : "   연결    ",
                            style: TextStyle(
                              color: Color(0xFF3C82F6),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      //테마
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: ExpansionTile(
                          title: Row(
                            children: [
                              Icon(Icons.nightlight_outlined),
                              Text(
                                "  테마",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          children: viewModel.themeList.map((option) {
                            return RadioListTile<String>(
                              title: Text(
                                option,
                                style: TextStyle(fontSize: 12),
                              ),
                              value: option,
                              groupValue: viewModel.selectedOption,
                              onChanged: (String? value) {
                                viewModel.updateThmem(value);
                                viewModel.saveTheme();
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      Padding(padding: EdgeInsets.all(5)),
                      //알림
                      CustomTab(
                        icon: Icons.notifications_active_outlined,
                        buttonText: "  알림",
                        padding: 0.0,
                        addWidget: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: viewModel.is_active_notification,
                            onChanged: (value) {
                              viewModel.activeNotification();
                              viewModel.updateNotification(viewModel.user!.id);
                            },
                            activeThumbColor: Colors.white,
                            activeTrackColor: Color(0xFF3C82F6),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      //온보딩 다시보기
                      GestureDetector(
                        onTap: () {
                          context.push("/login");
                        },
                        child: CustomTab(
                          icon: Icons.lightbulb_outline_rounded,
                          buttonText: "  앱 소개 다시보기",
                          padding: 7.0,
                          addWidget: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 20,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),

                      //회원탈퇴
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              context,
                              height: 280.0,
                              iconBackgroundColor: Color(0xFFFBE7F3),
                              icon: Icons.warning,
                              iconColor: Color(0xFFFFC943),
                              title: "회원탈퇴",
                              message: "정말 회원탈퇴 하시겠습니까?",
                              allow: "회원탈퇴",
                              announcement: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.yellow),
                                  color: Color(0xFFFEFCE8),
                                ),
                                child: SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "탈퇴 시 모든 데이터가 삭제되며 \n복구할 수 없습니다",
                                      style: TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              onChangeSelected: () => {
                                viewModel.deleteUser(),
                                context.pop(),
                                context.go('/login'),
                              },
                              onClosed: () => context.pop(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "회원탈퇴",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
