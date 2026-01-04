import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:dutytable/features/profile/presentation/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewmodel>();

    return GestureDetector(
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
    );
  }
}
