import 'package:dutytable/features/profile/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          // 앱바
          appBar: AppBar(
            title: Row(
              children: [
                const Text("프로필"),
                Spacer(),
                // 로그아웃 버튼
                GestureDetector(
                  onTap: () {
                    //로그아웃 다이얼로그
                    showDialog(
                      context: context,
                      builder: (context) => showDialog1(
                        context,
                        height: 240.0,
                        iconBackgroundColor: Color(0xFFDBE9FE),
                        icon: Icons.logout_outlined,
                        iconColor: Color(0xFF3C82F6),
                        title: "로그아웃",
                        message: "정말 로그아웃 하시겠습니까?",
                        allow: "로그아웃",
                        goto: '/login',
                      ),
                    );
                  },
                  child: Icon(Icons.logout),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Divider(),
                //프로필쪽
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Stack(
                      children: [
                        Icon(Icons.account_circle, size: 60),
                        // 프로필 수정 버튼 누를 시
                        (viewModel.is_edit)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  left: 30.0,
                                  top: 30,
                                ),
                                // 카메라 아이콘 추가
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 10,
                                    ),
                                    child: Icon(Icons.camera_alt_outlined),
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
                              controller: viewModel.nicknameContoller,
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
                            onTap: () {},
                            child: Text("   중복체크  "),
                          )
                        : Spacer(),
                    GestureDetector(
                      onTap: () {
                        viewModel.setProfileEdit();
                        viewModel.nickname = viewModel.nicknameContoller.text;
                      },
                      child: Text(
                        (viewModel.is_edit) ? "  저장  " : "수정",
                        style: TextStyle(color: Color(0xFF3C82F6)),
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
                            child: SizedBox(height: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF9FAFB),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(padding: EdgeInsets.all(7)),
                              Text(
                                "    내 계정 : casper118412@gmail.com",
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
                profileButton(
                  icon: Icons.settings,
                  buttonText: "  구글 캘린더 동기화",
                  padding: 7.0,
                  addWidget: GestureDetector(
                    onTap: () {
                      viewModel.googleSync();
                    },
                    child: Text(
                      (viewModel.is_sync) ? "연결해제    " : "  연결    ",
                      style: TextStyle(color: Color(0xFF3C82F6), fontSize: 12),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                //테마
                profileButton(
                  icon: Icons.nightlight_outlined,
                  buttonText: "  테마",
                  padding: 0.0,
                  addWidget: DropdownButton(
                    items: viewModel.themeList.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      viewModel.dropdownValue = value!;
                      viewModel.editTheme();
                    },
                    value: viewModel.dropdownValue,
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                //알림
                profileButton(
                  icon: Icons.notifications_active_outlined,
                  buttonText: "  알림",
                  padding: 0.0,
                  addWidget: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: viewModel.is_active,
                      onChanged: (value) {
                        viewModel.activeAlram();
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
                  child: profileButton(
                    icon: Icons.lightbulb_outline_rounded,
                    buttonText: "  앱 소개 다시보기",
                    padding: 7.0,
                    addWidget: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),

                //회원탈퇴
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => showDialog1(
                        context,
                        height: 280.0,
                        iconBackgroundColor: Color(0xFFFBE7F3),
                        icon: Icons.warning,
                        iconColor: Color(0xFFFFC943),
                        title: "회원탈퇴",
                        message: "정말 회원탈퇴 하시겠습니까?",
                        allow: "회원탈퇴",
                        goto: '/login',
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
                      ),
                    );
                  },
                  child: Text("회원탈퇴", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 다이얼로그
Widget showDialog1(
  BuildContext context, {

  /// 다이얼로그 높이
  required height,

  /// 아이콘배경색
  required iconBackgroundColor,

  /// 아이콘
  required icon,

  /// 아이콘 색
  required iconColor,

  /// 다이얼로그 이름
  required title,

  /// 다이얼로그 설명
  required message,

  /// 확인버튼
  required allow,

  /// 버튼 선택 시 경로
  required goto,

  ///더 추가할 위젯
  Widget? announcement,
}) {
  return Dialog(
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: 300,
          height: height,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(13)),
              Stack(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: iconBackgroundColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(icon, color: iconColor),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(5)),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.all(5)),
              Text(message, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Padding(padding: EdgeInsets.all(5)),
              (announcement != null)
                  ? announcement
                  : Padding(padding: EdgeInsets.all(1)),

              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text("   취소   ", style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF3F4F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  ElevatedButton(
                    onPressed: () {
                      context.push(goto);
                    },
                    child: Text(
                      allow,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

///프로필스크린에 있는 각 설정 항목
Widget profileButton({
  /// 항목에 들어갈 아이콘
  required icon,

  /// 항목에 들어갈 텍스트
  required buttonText,

  /// 항목 텍스트 가운데 정렬
  required padding,

  ///더 추가할 위젯
  Widget? addWidget,
}) {
  return Row(
    children: [
      Padding(padding: EdgeInsets.only(left: 20)),
      Expanded(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              child: SizedBox(height: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
            ),
            Column(
              children: [
                Padding(padding: EdgeInsets.all(padding)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.all(7)),
                    Icon(icon, size: 25),
                    Text(buttonText, style: TextStyle(fontSize: 12)),
                    Spacer(),
                    (addWidget == null) ? Container() : addWidget,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      Padding(padding: EdgeInsets.only(left: 20)),
    ],
  );
}
