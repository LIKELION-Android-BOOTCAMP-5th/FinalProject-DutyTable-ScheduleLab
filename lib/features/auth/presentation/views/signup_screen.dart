import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/configs/app_colors.dart';
import '../viewmodels/signup_viewmodel.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupViewModel(),
      child: const _SignupScreenUI(),
    );
  }
}

class _SignupScreenUI extends StatelessWidget {
  const _SignupScreenUI({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 테마 설정 확인
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 배경색 결정
    final Color scaffoldBgColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    // 카드 배경색 결정
    final Color cardBgColor = isDarkMode
        ? AppColors.cardBackgroundDark
        : AppColors.cardBackgroundLight;

    // 입력 필드 배경색 (카드 배경과 구분되도록 약간 밝게/어둡게 조정)
    final Color inputFieldColor = isDarkMode
        ? Color.lerp(cardBgColor, Colors.white, 0.07)! // 다크 모드: 카드 배경보다 약간 밝게
        : Color.lerp(
            cardBgColor,
            Colors.black,
            0.05,
          )!; // 라이트 모드: 카드 배경보다 약간 어둡게

    // 텍스트 색상 결정
    final Color textColor = isDarkMode
        ? AppColors.textDark
        : AppColors.textLight;

    // 서브 텍스트 (힌트/약관) 색상
    final Color subTextColor = isDarkMode ? Colors.white70 : Colors.grey;

    // 화면 터치 시 키보드 숨김
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<SignupViewModel>(
        builder: (context, viewmodel, child) {
          // '완료' 버튼 활성화 여부
          final bool isButtonEnabled =
              viewmodel.isFormComplete && !viewmodel.isLoading;

          return Scaffold(
            backgroundColor: scaffoldBgColor,
            appBar: AppBar(
              backgroundColor: scaffoldBgColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 80),

                  // 프로필 이미지
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? Colors.black45 : Colors.black12,
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: cardBgColor, // 카드 배경색 사용
                      child: Text(
                        '프로필',
                        style: TextStyle(color: subTextColor, fontSize: 16),
                      ),
                    ),
                  ),

                  // TODO: 나중에 프로필 사진 업로드 버튼이나 아이콘 추가 가능
                  const SizedBox(height: 20),

                  // 회원가입 타이틀
                  Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 입력 카드
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.5) // 다크모드 그림자
                              : AppColors.cardShadowLight.withOpacity(
                                  0.4,
                                ), // 라이트모드 그림자
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 닉네임 입력 필드 및 중복 체크
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
                            SizedBox(
                              height: 40,
                              child: GestureDetector(
                                onTap:
                                    viewmodel.isNicknameValid &&
                                        !viewmodel.isLoading
                                    ? viewmodel.checkNicknameDuplication
                                    : null, // 닉네임이 유효하지 않거나 로딩 중이면 비활성화
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        viewmodel.isNicknameValid &&
                                            !viewmodel.isLoading
                                        ? AppColors.actionPositiveLight
                                        : Colors.grey, // 비활성화 상태 색상
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
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // 중복 확인 결과 메시지
                        if (viewmodel.isNicknameChecked)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '사용 가능한 닉네임입니다.',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // 약관 동의 섹션
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: viewmodel.isTermsAgreed,
                                onChanged: viewmodel.isLoading
                                    ? null
                                    : viewmodel
                                          .toggleTermsAgreement, // 로딩 중이면 체크박스 비활성화
                                activeColor: AppColors.actionPositiveLight,
                                checkColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '약관동의의 약관...',
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: 약관 전체 보기 모달 또는 화면 표시
                              },
                              child: const Text(
                                '전체보기',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue, // 로그인 화면과 동일한 색상 사용
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
                                : Colors.grey, // 비활성화 상태 색상
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
