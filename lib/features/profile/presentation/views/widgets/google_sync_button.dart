import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_view_model.dart';
import 'package:dutytable/features/profile/presentation/widgets/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../calendar/presentation/viewmodels/personal_calendar_view_model.dart';

class GoogleSyncButton extends StatelessWidget {
  const GoogleSyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewmodel>();
    return CustomTab(
      icon: Icons.settings_outlined,
      buttonText: "구글 캘린더 동기화",
      padding: 7.0,
      addWidget: GestureDetector(
        onTap: () async {
          await viewModel.googleSync();
          await context.read<PersonalCalendarViewModel>().fetchCalendar();
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
    );
  }
}
