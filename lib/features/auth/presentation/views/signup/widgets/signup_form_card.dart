import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/auth/presentation/viewmodels/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'signup_terms_row.dart';

class SignupFormCard extends StatelessWidget {
  final bool isDark;
  final SignupViewModel viewmodel;

  const SignupFormCard({
    super.key,
    required this.isDark,
    required this.viewmodel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.dBorder : AppColors.lBorder,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 닉네임 + 중복체크
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: viewmodel.nicknameController,
                  style: TextStyle(color: AppColors.textMain(context)),
                  decoration: InputDecoration(
                    hintText: '닉네임을 입력하세요',
                    hintStyle: TextStyle(color: AppColors.textSub(context)),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    filled: true,
                    fillColor: AppColors.background(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 40,
                width: 80,
                child: GestureDetector(
                  onTap: viewmodel.isNicknameValid && !viewmodel.isLoading
                      ? viewmodel.checkNicknameDuplication
                      : null,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: viewmodel.isNicknameValid && !viewmodel.isLoading
                          ? AppColors.primaryBlue
                          : AppColors.iconSub(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: viewmodel.isLoading && !viewmodel.isNicknameChecked
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              color: AppColors.primary(context),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            '중복 체크',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.pureWhite,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),

          // 닉네임 메시지
          if (viewmodel.nicknameMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                viewmodel.nicknameMessage!,
                style: TextStyle(
                  color: viewmodel.isNicknameMessageError
                      ? AppColors.pureDanger
                      : AppColors.pureSuccess,
                  fontSize: 12,
                ),
              ),
            ),

          const SizedBox(height: 20),

          SignupTermsRow(
            isLoading: viewmodel.isLoading,
            hasViewedTerms: viewmodel.hasViewedTerms,
            isTermsAgreed: viewmodel.isTermsAgreed,
            onToggleAgreement: viewmodel.toggleTermsAgreement,
            onViewTerms: () async {
              viewmodel.viewTerms();

              final Uri notionUrl = Uri.parse(
                'https://www.notion.so/2bf73873401a804cb9a8ef0b68a4d71c',
              );

              if (await canLaunchUrl(notionUrl)) {
                await launchUrl(notionUrl);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'URL을 열 수 없습니다.',
                      style: TextStyle(color: AppColors.textMain(context)),
                    ),
                    backgroundColor: AppColors.danger(context),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
