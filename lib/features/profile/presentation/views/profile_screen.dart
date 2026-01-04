import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/logo_actions_app_bar.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:dutytable/features/profile/presentation/views/widgets/profile_button_section.dart';
import 'package:dutytable/features/profile/presentation/views/widgets/user_profile_section.dart';
import 'package:dutytable/features/profile/presentation/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../onboarding/presentation/views/onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewmodel(),
      child: const _ProfileScreen(),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ProfileViewmodel>(
      builder: (context, viewModel, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background(context),
              appBar: LogoActionsAppBar(
                leftActions: Text(
                  "프로필",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.textMain(context),
                  ),
                ),
                rightActions: GestureDetector(
                  onTap: () {
                    //로그아웃 다이얼로그
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        context,
                        height: 240.0,
                        iconBackgroundColor: const Color(0xFFDBE9FE),
                        icon: Icons.logout_outlined,
                        iconColor: AppColors.primaryBlue,
                        title: "로그아웃",
                        message: "정말 로그아웃 하시겠습니까?",
                        allow: "로그아웃",
                        onChangeSelected: () {
                          viewModel.logout();
                          context.pop();
                          context.go('/login');
                        },
                        onClosed: () => context.pop(),
                      ),
                    );
                  },
                  child: Icon(Icons.logout, color: AppColors.iconSub(context)),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // 프로필 섹션
                      UserProfileSection(),

                      // 버튼 섹션(동기화, 테마, 알림, 앱소개 다시보기)
                      ProfileButtonSection(),

                      // 회원탈퇴
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              context,
                              height: 280.0,
                              iconBackgroundColor: isDarkMode
                                  ? const Color(0xFF451225)
                                  : const Color(0xFFFBE7F3),
                              icon: Icons.warning,
                              iconColor: AppColors.danger(context),
                              title: "회원탈퇴",
                              message: "정말 회원탈퇴 하시겠습니까?",
                              allow: "회원탈퇴",
                              announcement: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.warningBannerBorder(
                                      context,
                                    ),
                                  ),
                                  color: AppColors.warningBanner(context),
                                ),
                                child: SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "탈퇴 시 모든 데이터가 삭제되며 \n복구할 수 없습니다",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textMain(context),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              onChangeSelected: () {
                                viewModel.deleteUser();
                                context.pop();
                                context.go('/login');
                              },
                              onClosed: () => context.pop(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "회원탈퇴",
                            style: TextStyle(color: AppColors.danger(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ?viewModel.isShowOnboarding
                ? OnboardingScreen(onFinished: viewModel.toggleOnboarding)
                : null,
          ],
        );
      },
    );
  }
}
