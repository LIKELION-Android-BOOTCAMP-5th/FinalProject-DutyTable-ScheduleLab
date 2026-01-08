import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

import '../../data/models/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPageItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              data.image,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.body,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSub(context),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
