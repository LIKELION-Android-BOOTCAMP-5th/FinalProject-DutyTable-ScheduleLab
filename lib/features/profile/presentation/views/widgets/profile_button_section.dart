import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/providers/theme_provider.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:dutytable/features/profile/presentation/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class second_section extends StatelessWidget {
  const second_section({super.key});

  @override
  Widget build(BuildContext context) {
    // 테마 변경 실시간 감지를 위해 watch 사용
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<ProfileViewmodel>();

    return Column(
      children: [
        CustomTab(
          icon: Icons.settings_outlined,
          buttonText: "구글 캘린더 동기화",
          padding: 7.0,
          addWidget: GestureDetector(
            onTap: () async {
              await viewModel.googleSync();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                (viewModel.is_sync) ? "연결해제" : "연결",
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Text(
                      "테마",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain(context),
                      ),
                    ),
                  ),
                ],
              ),
              collapsedShape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isDarkMode ? AppColors.dBorder : AppColors.lBorder,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.primary(context), width: 2.0),
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
          buttonText: "알림",
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
            buttonText: "앱 소개 다시보기",
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
      ],
    );
  }
}
