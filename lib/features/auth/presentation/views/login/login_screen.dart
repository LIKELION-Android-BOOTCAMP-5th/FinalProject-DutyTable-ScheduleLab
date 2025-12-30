import 'dart:io';

import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/login_logo_section.dart';
import 'widgets/auto_login_row.dart';
import 'widgets/auth_buttons_section.dart';
import 'widgets/onboarding_overlay.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginScreenUI(),
    );
  }
}

// UI 구조와 이벤트를 담당하는 위젯 (여기서도 최대한 "조립"만)
class _LoginScreenUI extends StatelessWidget {
  const _LoginScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<LoginViewModel>();
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
                  const Expanded(child: LoginLogoSection()),

                  AutoLoginRow(
                    isDarkMode: isDarkMode,
                    isAutoLogin: viewmodel.isAutoLogin,
                    onChanged: (value) {
                      if (value == null) return;
                      viewmodel.setAutoLogin(value);
                    },
                  ),

                  AuthButtonsSection(
                    showApple: Platform.isIOS,
                    onGoogleTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      viewmodel.googleSignIn(
                        context,
                        isAutoLogin: viewmodel.isAutoLogin,
                      );
                    },
                    onAppleTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      viewmodel.signInWithApple(
                        context,
                        isAutoLogin: viewmodel.isAutoLogin,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // 온보딩 오버레이
        OnboardingOverlay(
          visible: viewmodel.showOnboarding,
          onFinished: viewmodel.finishOnboarding,
        ),
      ],
    );
  }
}
