import 'dart:io';

import 'package:dutytable/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:dutytable/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/configs/app_colors.dart';

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
class _LoginScreenUI extends StatefulWidget {
  const _LoginScreenUI({super.key});

  @override
  State<_LoginScreenUI> createState() => _LoginScreenUIState();
}

class _LoginScreenUIState extends State<_LoginScreenUI> {
  bool _isAutoLogin = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isOnboardingDone = prefs.getBool('isOnboardingDone') ?? false;
    if (!isOnboardingDone) {
      setState(() {
        _showOnboarding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background(context),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 40.0,
              ),
              child: Column(
                children: [
                  // 로고 섹션
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/calendar_logo.png',
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'DutyTable',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMain(context),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "DutyTable에 오신걸 환영합니다!",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSub(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 자동로그인
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _isAutoLogin,
                            activeColor: AppColors.primaryBlue,
                            checkColor: AppColors.pureWhite,
                            side: BorderSide(
                              color: isDarkMode
                                  ? AppColors.dBorder
                                  : AppColors.lBorder,
                            ),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _isAutoLogin = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '자동 로그인',
                          style: TextStyle(color: AppColors.textMain(context)),
                        ),
                      ],
                    ),
                  ),

                  // 버튼 섹션
                  Consumer<LoginViewModel>(
                    builder: (context, viewmodel, child) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                /// 에러 방지를 위해 호출 전 기존 스낵바 제거
                                ScaffoldMessenger.of(
                                  context,
                                ).hideCurrentSnackBar();
                                viewmodel.googleSignIn(
                                  context,
                                  isAutoLogin: _isAutoLogin,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  '구글로 계속하기',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.pureWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // 아이폰만 표시
                          //TODO: 나중에 안드로이드에서도 애플 로그인 지원 여부 검토
                          if (Platform.isIOS) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: SignInWithAppleButton(
                                onPressed: () {
                                  /// 안드로이드와 마찬가지 - 스낵바 에러 방지를 위해 호출 전 기존 스낵바 제거
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                  viewmodel.signInWithApple(
                                    context,
                                    isAutoLogin: _isAutoLogin,
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showOnboarding)
          OnboardingScreen(
            onFinished: () {
              setState(() {
                _showOnboarding = false;
              });
            },
          ),
      ],
    );
  }
}
