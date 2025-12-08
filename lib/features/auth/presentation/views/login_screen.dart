import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/configs/app_colors.dart';
import '../viewmodels/login_viewmodel.dart';

<<<<<<< Updated upstream
// 로그인 화면의 엔트리 포인트 위젯
// ChangeNotifierProvider를 사용하여 LoginViewModel을 하위 위젯에 제공
=======
>>>>>>> Stashed changes
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider를 통해 LoginViewModel 인스턴스를 생성하고,
    // _LoginScreenUI 위젯에 상태 관리를 위임
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: const _LoginScreenUI(),
    );
  }
}

<<<<<<< Updated upstream
// 실제 로그인 화면의 UI 구조와 이벤트를 담당하는 위젯
=======
// UI 구조와 이벤트를 담당하는 위젯
>>>>>>> Stashed changes
class _LoginScreenUI extends StatelessWidget {
  const _LoginScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    // 화면 높이를 반응형 UI에 사용하기 위해 가져옴
    final double screenHeight = MediaQuery.of(context).size.height;

    // 현재 테마의 밝기 (Dark/Light)를 확인하여 UI 요소 색상 결정
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
=======
    final double screenHeight = MediaQuery.of(context).size.height;

    // 현재 테마의 밝기 (Dark/Light)를 확인
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // AppColors 사용
>>>>>>> Stashed changes
    final Color titleColor = isDarkMode
        ? AppColors.textDark
        : AppColors.textLight;
    final Color subTextColor = isDarkMode ? Colors.white70 : Colors.grey;
<<<<<<< Updated upstream
=======

    // 배경색 결정
>>>>>>> Stashed changes
    final Color scaffoldBgColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
<<<<<<< Updated upstream
          // Column을 사용하여 위젯을 수직으로 배치
          // MainAxisAlignment.spaceBetween으로 로고와 버튼 섹션을 위아래로 분산
=======
>>>>>>> Stashed changes
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
<<<<<<< Updated upstream
              // 상단 여백
              SizedBox(height: screenHeight * 0.15),

              // 로고 및 앱 이름 섹션
=======
              SizedBox(height: screenHeight * 0.15),

              // 로고 섹션
>>>>>>> Stashed changes
              Column(
                children: [
                  Image.asset(
                    'assets/images/calendar_logo.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'DutyTable',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                ],
              ),

<<<<<<< Updated upstream
              // 하단 버튼 섹션
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                // Consumer 위젯을 사용하여 LoginViewModel의 상태 변화를 감지하고 UI를 다시 빌드
=======
              // 버튼 섹션
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
>>>>>>> Stashed changes
                child: Consumer<LoginViewModel>(
                  builder: (context, viewmodel, child) {
                    return Column(
                      children: [
                        // 환영 메시지
                        Text(
                          '로그인 화면에 오신걸 환영합니다!',
                          style: TextStyle(fontSize: 16, color: subTextColor),
                        ),
                        const SizedBox(height: 50),

                        // '구글로 계속하기' 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: GestureDetector(
<<<<<<< Updated upstream
                            // 버튼 탭 시 ViewModel의 googleSignIn 함수 호출
=======
>>>>>>> Stashed changes
                            onTap: () {
                              viewmodel.googleSignIn(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.actionPositiveLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '구글로 계속하기',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
