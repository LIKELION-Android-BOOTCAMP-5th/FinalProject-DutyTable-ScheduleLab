import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/auth/presentation/viewmodels/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/image_picker_utils.dart';
import 'widgets/signup_app_bar.dart';
import 'widgets/signup_form_card.dart';
import 'widgets/signup_profile_image_picker.dart';
import 'widgets/signup_submit_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: const _SignupScreenUI(),
    );
  }
}

class _SignupScreenUI extends StatelessWidget {
  const _SignupScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<SignupViewModel>(
        builder: (context, viewmodel, child) {
          final bool isButtonEnabled =
              viewmodel.isFormComplete && !viewmodel.isLoading;

          return Scaffold(
            backgroundColor: AppColors.background(context),
            appBar: const SignupAppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 80),

                  SignupProfileImagePicker(
                    selectedImage: viewmodel.selectedImage,
                    onPickImage: () {
                      ImagePickerUtils.showImagePicker(
                        context: context,
                        onImageSelected: (source) =>
                            viewmodel.pickProfileImage(source),
                        onDelete: viewmodel.deleteImage,
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain(context),
                    ),
                  ),
                  const SizedBox(height: 40),

                  SignupFormCard(
                    isDark: isDark,
                    viewmodel: viewmodel, // 화면 전용이라 VM 전달(편의)
                  ),

                  const SizedBox(height: 40),

                  SignupSubmitButton(
                    isLoading: viewmodel.isLoading,
                    enabled: isButtonEnabled,
                    onTap: () => viewmodel.completeSignup(context),
                  ),

                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
