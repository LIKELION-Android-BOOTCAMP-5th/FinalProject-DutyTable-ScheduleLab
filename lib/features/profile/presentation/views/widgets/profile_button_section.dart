import 'package:dutytable/features/profile/presentation/views/widgets/alarm_setting_button.dart';
import 'package:dutytable/features/profile/presentation/views/widgets/google_sync_button.dart';
import 'package:dutytable/features/profile/presentation/views/widgets/onboarding_button.dart';
import 'package:dutytable/features/profile/presentation/views/widgets/theme_button.dart';
import 'package:flutter/material.dart';

class ProfileButtonSection extends StatelessWidget {
  const ProfileButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 구글 동기화 버튼
        GoogleSyncButton(),
        const Padding(padding: EdgeInsets.all(5)),

        // 테마 버튼
        ThemeButton(),
        const Padding(padding: EdgeInsets.all(5)),

        // 알림 설정 버튼
        AlarmSettingButton(),
        const Padding(padding: EdgeInsets.all(5)),

        // 앱 소개 다시보기
        OnboardingButton(),
        const Padding(padding: EdgeInsets.all(5)),
      ],
    );
  }
}
