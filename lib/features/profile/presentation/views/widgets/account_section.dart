import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/profile/presentation/viewmodels/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewmodel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.surface(context), // 배경색 대응
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "내 계정 : ${viewModel.email}",
            style: TextStyle(fontSize: 12, color: AppColors.textSub(context)),
          ),
        ),
      ),
    );
  }
}
