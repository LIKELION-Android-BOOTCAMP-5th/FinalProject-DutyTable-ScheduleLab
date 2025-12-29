import 'package:dutytable/core/di/injection.dart';
import 'package:dutytable/features/onboarding/presentation/args/onboarding_args.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/configs/app_colors.dart';
import '../../data/models/onboarding_model.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onFinished;

  const OnboardingScreen({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OnboardingViewModel>(
        param1: OnboardingArgs(
          totalPages: onboardingPages.length,
          onFinished: onFinished,
        ),
      ),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Consumer<OnboardingViewModel>(
          builder: (context, vm, _) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: vm.skip,
                      child: Text(
                        '건너뛰기',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSub(context),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: vm.pageController,
                    onPageChanged: vm.onPageChanged,
                    itemCount: onboardingPages.length,
                    itemBuilder: (context, index) {
                      return OnboardingPageItem(data: onboardingPages[index]);
                    },
                  ),
                ),
                OnboardingIndicator(
                  currentIndex: vm.currentPage,
                  length: onboardingPages.length,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: vm.goToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.textMain(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        vm.currentPage == onboardingPages.length - 1
                            ? '시작하기'
                            : '다음',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
