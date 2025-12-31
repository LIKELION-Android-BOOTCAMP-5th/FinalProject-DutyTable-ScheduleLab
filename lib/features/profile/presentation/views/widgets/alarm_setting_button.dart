import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:dutytable/features/profile/presentation/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmSettingButton extends StatelessWidget {
  const AlarmSettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewmodel>();

    return CustomTab(
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
    );
  }
}
