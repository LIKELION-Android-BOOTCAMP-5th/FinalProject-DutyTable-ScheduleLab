import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/configs/app_colors.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: const _LoginScreenUI(),
    );
  }
}

// UI 구조와 이벤트를 담당하는 위젯
class _LoginScreenUI extends StatelessWidget {
  const _LoginScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    // 현재 테마의 밝기 (Dark/Light)를 확인
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // AppColors 사용
    final Color titleColor = isDarkMode
        ? AppColors.textDark
        : AppColors.textLight;
    final Color subTextColor = isDarkMode ? Colors.white70 : Colors.grey;

    // 배경색 결정
    final Color scaffoldBgColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.15),

              // 로고 섹션
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

              // 버튼 섹션
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
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
