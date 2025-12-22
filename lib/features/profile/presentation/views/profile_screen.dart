import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/providers/theme_provider.dart';
import 'package:dutytable/core/widgets/logo_actions_app_bar.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:dutytable/features/profile/presentation/widgets/custom_dialog.dart';
import 'package:dutytable/features/profile/presentation/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // 테마 변경 실시간 감지를 위해 watch 사용
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ProfileViewmodel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          // 배경색 대응
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
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),

                    // 프로필 섹션
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Stack(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child:
                                  (viewModel.image == null ||
                                      viewModel.image!.isEmpty)
                                  ? Icon(
                                      Icons.account_circle,
                                      size: 60,
                                      color: AppColors.iconSub(context),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        viewModel.image!,
                                        width: double.infinity,
                                        height: 350,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            if (viewModel.is_edit)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    await viewModel.getImage(
                                      ImageSource.gallery,
                                    );
                                    await viewModel.upload();
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: AppColors.primary(context),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 14,
                                      color: AppColors.pureWhite,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        if (viewModel.is_edit)
                          Expanded(
                            child: TextField(
                              controller: viewModel.nicknameController,
                              style: TextStyle(
                                color: AppColors.textMain(context),
                              ),
                              decoration: InputDecoration(
                                hintText: "닉네임을 입력해주세요",
                                hintStyle: TextStyle(
                                  color: AppColors.textSub(context),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.lBorder,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Text(
                            viewModel.nickname,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain(context),
                            ),
                          ),
                        if (viewModel.is_edit)
                          TextButton(
                            onPressed: () => viewModel.nicknameOverlapping(),
                            child: const Text("중복체크"),
                          )
                        else
                          const Spacer(),
                        GestureDetector(
                          onTap: () => viewModel.nicknameButtonFunc(),
                          child: Text(
                            viewModel.nicknameButtonText(),
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    // 내 계정 섹션
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.surface(context), // 배경색 대응
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "   내 계정 : ${viewModel.email}",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSub(context),
                          ),
                        ),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.all(7)),

                    // 구글 캘린더 동기화
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
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),

                    // 테마 설정 (ExpansionTile) - 리플 효과 삭제
                    Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(splashFactory: NoSplash.splashFactory),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ExpansionTile(
                          iconColor: AppColors.textMain(context),
                          collapsedIconColor: AppColors.iconSub(context),
                          title: Row(
                            children: [
                              Icon(
                                Icons.nightlight_outlined,
                                color: AppColors.textMain(context),
                              ),
                              Text(
                                "  테마",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textMain(context),
                                ),
                              ),
                            ],
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: isDarkMode
                                  ? AppColors.dBorder
                                  : AppColors.lBorder,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.primary(context),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          children: themeProvider.themeList.map((option) {
                            return RadioListTile<String>(
                              title: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMain(context),
                                ),
                              ),
                              value: option,
                              groupValue: themeProvider.selectedOption,
                              activeColor: AppColors.primaryBlue,
                              onChanged: (value) {
                                if (value != null) {
                                  themeProvider.updateTheme(value);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.all(5)),

                    // 알림 설정
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
                          activeThumbColor: AppColors.pureWhite,
                          activeTrackColor: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),

                    // 앱 소개 다시보기
                    GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("isOnboardingDone", false);
                        viewModel.logout();
                        if (context.mounted) context.push("/login");
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
                            color: AppColors.textSub(context),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),

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
                                  color: AppColors.warningBannerBorder(context),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
