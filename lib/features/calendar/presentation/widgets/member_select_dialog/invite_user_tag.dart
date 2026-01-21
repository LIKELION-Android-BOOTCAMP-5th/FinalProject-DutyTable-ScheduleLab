import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_add_view_model.dart';
import 'package:flutter/material.dart';

class InviteUserTag extends StatelessWidget {
  final CalendarAddViewModel viewModel;

  const InviteUserTag({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: viewModel.invitedUsers
          .map(
            (user) => Chip(
              backgroundColor: AppColors.background(context),
              label: Text(
                user.nickname,
                style: TextStyle(color: AppColors.textMain(context)),
              ),
              onDeleted: () => viewModel.removeInvitedUser(user.id),
            ),
          )
          .toList(),
    );
  }
}
