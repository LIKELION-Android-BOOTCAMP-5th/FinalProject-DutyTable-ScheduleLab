import 'package:flutter/material.dart';

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
    final viewModel = OnboardingViewModel(
      totalPages: onboardingPages.length,
      onFinished: onFinished,
    );

    return _OnboardingView(viewModel: viewModel);
  }
}

class _OnboardingView extends StatefulWidget {
  final OnboardingViewModel viewModel;

  const _OnboardingView({super.key, required this.viewModel});

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  OnboardingViewModel get vm => widget.viewModel;

  @override
  void dispose() {
    vm.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: vm,
          builder: (context, _) {
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

// //stateful을 stateless로 변경
// //viewmodel로 빼기
// class OnboardingScreen extends StatefulWidget {
//   final VoidCallback onFinished;
//
//   const OnboardingScreen({super.key, required this.onFinished});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _onPageChanged(int page) {
//     setState(() {
//       _currentPage = page;
//     });
//   }
//
//   void _goToNextPage() {
//     if (_currentPage < onboardingPages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeIn,
//       );
//     } else {
//       _goToLogin();
//     }
//   }
//
//   void _goToLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool("isOnboardingDone", true);
//     widget.onFinished();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background(context),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 16, right: 16),
//               child: Align(
//                 alignment: Alignment.topRight,
//                 child: TextButton(
//                   onPressed: _goToLogin,
//                   child: Text(
//                     '건너뛰기',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textSub(context),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 onPageChanged: _onPageChanged,
//                 itemCount: onboardingPages.length,
//                 itemBuilder: (context, index) {
//                   return OnboardingPageItem(data: onboardingPages[index]);
//                 },
//               ),
//             ),
//             OnboardingIndicator(
//               currentIndex: _currentPage,
//               length: onboardingPages.length,
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed: _goToNextPage,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryBlue,
//                     foregroundColor: AppColors.textMain(context),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     _currentPage == onboardingPages.length - 1 ? '시작하기' : '다음',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.pureWhite,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }
