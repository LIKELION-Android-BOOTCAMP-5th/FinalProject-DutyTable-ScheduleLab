import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:flutter/material.dart';

class InviteUserTag extends StatelessWidget {
  final SharedCalendarViewModel viewModel;

  const InviteUserTag({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: viewModel.invitedUsers.entries
          .map(
            (e) => Chip(
              backgroundColor: AppColors.background(context),
              label: Text(
                e.value,
                style: TextStyle(color: AppColors.textMain(context)),
              ),
              onDeleted: () => viewModel.removeInvitedUser(e.key),
            ),
          )
          .toList(),
    );
  }
}
