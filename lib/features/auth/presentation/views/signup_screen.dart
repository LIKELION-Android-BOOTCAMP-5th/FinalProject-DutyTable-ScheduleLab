import 'package:dutytable/features/auth/presentation/viewmodels/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/configs/app_colors.dart';

// 회원가입 화면의 엔트리 포인트 위젯
// ChangeNotifierProvider를 사용하여 SignupViewModel을 하위 위젯에 제공
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider를 통해 SignupViewModel 인스턴스를 생성하고,
    // _SignupScreenUI 위젯에 상태 관리를 위임
    return ChangeNotifierProvider(
      create: (context) => SignupViewModel(),
      child: const _SignupScreenUI(),
    );
  }
}

// 실제 회원가입 화면의 UI 구조와 이벤트를 담당하는 위젯
class _SignupScreenUI extends StatelessWidget {
  const _SignupScreenUI({super.key});

  // 프로필 이미지 선택 위젯을 빌드하는 함수
  Widget _buildImagePicker(BuildContext context, SignupViewModel viewModel) {
    ImageProvider? imageProvider;

    // 회원가입 화면에서는 기존 이미지 URL이 없으므로 FileImage만 처리
    if (viewModel.selectedImage != null) {
      imageProvider = FileImage(viewModel.selectedImage!);
    }

    return Stack(
      children: [
        // 그림자 효과와 함께 프로필 이미지를 표시하는 CircleAvatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.boxShadow(context),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.card(context),
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(Icons.photo, size: 40, color: AppColors.subText(context))
                : null,
          ),
        ),
        // 이미지 변경을 위한 카메라 아이콘 버튼
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12, width: 2),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.camera_alt, color: Colors.black45, size: 20),
              onPressed: () => viewModel.pickImage(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 테마 및 색상 설정
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBgColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final Color cardBgColor = isDarkMode
        ? AppColors.cardBackgroundDark
        : AppColors.cardBackgroundLight;
    final Color inputFieldColor = isDarkMode
        ? Color.lerp(cardBgColor, Colors.white, 0.07)!
        : Color.lerp(cardBgColor, Colors.black, 0.05)!;
    final Color textColor = isDarkMode
        ? AppColors.textDark
        : AppColors.textLight;
    final Color subTextColor = isDarkMode ? Colors.white70 : Colors.grey;

    // 화면의 다른 곳을 탭하면 키보드를 숨기기 위한 GestureDetector
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // Consumer 위젯을 사용하여 SignupViewModel의 상태 변화를 감지하고 UI를 동적으로 빌드
      child: Consumer<SignupViewModel>(
        builder: (context, viewmodel, child) {
          // ViewModel의 상태에 따라 '완료' 버튼의 활성화 여부 결정
          final bool isButtonEnabled =
              viewmodel.isFormComplete && !viewmodel.isLoading;

          return Scaffold(
            backgroundColor: scaffoldBgColor,
            appBar: AppBar(
              backgroundColor: scaffoldBgColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                // 뒤로가기 버튼 클릭 시 로그인 화면으로 이동
                onPressed: () => context.go('/login'),
              ),
            ),
            // SingleChildScrollView를 사용하여 키보드가 올라올 때 화면이 잘리지 않도록 함
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 80),

                  // 프로필 이미지 선택 섹션
                  _buildImagePicker(context, viewmodel),

                  const SizedBox(height: 20),

                  Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 입력 폼 카드
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.5)
                              : AppColors.cardShadowLight.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 닉네임 입력 및 중복 체크
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: viewmodel.nicknameController,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: '닉네임을 입력하세요',
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(0.6),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  filled: true,
                                  fillColor: inputFieldColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 중복 체크 버튼
                            SizedBox(
                              height: 40,
                              width: 80,
                              child: GestureDetector(
                                onTap:
                                    viewmodel.isNicknameValid &&
                                        !viewmodel.isLoading
                                    ? viewmodel.checkNicknameDuplication
                                    : null, // 조건에 따라 버튼 활성화/비활성화
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        viewmodel.isNicknameValid &&
                                            !viewmodel.isLoading
                                        ? AppColors.actionPositiveLight
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      viewmodel.isLoading &&
                                          !viewmodel.isNicknameChecked
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          '중복 체크',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // 닉네임 유효성 검사 메시지
                        if (viewmodel.nicknameMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              viewmodel.nicknameMessage!,
                              style: TextStyle(
                                color: viewmodel.isNicknameMessageError
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),

                        // 약관 동의 섹션
                        Row(
                          children: [
                            Checkbox(
                              value: viewmodel.isTermsAgreed,
                              onChanged:
                                  viewmodel.isLoading ||
                                      !viewmodel.hasViewedTerms
                                  ? null // 로딩 중이거나 약관을 안 봤으면 비활성화
                                  : viewmodel.toggleTermsAgreement,
                              activeColor: AppColors.actionPositiveLight,
                              checkColor: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '약관동의',
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            // '전체보기' 버튼 클릭 시 외부 URL(노션) 실행
                            TextButton(
                              onPressed: () async {
                                viewmodel.viewTerms();
                                final Uri notionUrl = Uri.parse(
                                  'https://www.notion.so/2bf73873401a804cb9a8ef0b68a4d71c',
                                );
                                if (await canLaunchUrl(notionUrl)) {
                                  await launchUrl(notionUrl);
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('URL을 열 수 없습니다.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                '전체보기',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 완료 버튼
                  const SizedBox(height: 40),
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: GestureDetector(
                        onTap: isButtonEnabled
                            ? () => viewmodel.completeSignup(context)
                            : null,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isButtonEnabled
                                ? AppColors.actionPositiveLight
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: viewmodel.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  '완료',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
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
