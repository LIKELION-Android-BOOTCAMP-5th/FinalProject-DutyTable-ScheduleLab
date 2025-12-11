import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/widgets/loading_dialog.dart';
import '../../../../main.dart';
import '../../../../supabase_manager.dart';
import '../../../../supabase_user_model.dart';

// LoginScreen의 비즈니스 로직을 관리하는 ViewModel
class LoginViewModel extends ChangeNotifier {
  // 구글 로그인 시 얻는 사용자 정보
  GoogleSignInAccount? _googleUser;

  // 외부에서 구글 사용자 정보에 접근하기 위한 getter
  GoogleSignInAccount? get googleUser => _googleUser;
  // Supabase에 저장된 사용자 프로필 정보
  SupabaseUserModel? userAccount;

  // 구글 로그인을 처리하는 메인 함수
  Future<void> googleSignIn(
    BuildContext context, {
    required bool isAutoLogin,
  }) async {
    // 전체 화면 로딩 인디케이터 표시
    showFullScreenLoading(context);
    try {
      // 구글 로그인 시 요청할 권한 범위
      final scopes = ['email', 'profile'];
      final String? platformClientId;

      if (Platform.isIOS) {
        platformClientId =
            '174693600398-kt7o6r2jne782tkfbna9g5sl9b72vdjm.apps.googleusercontent.com';
      } else if (Platform.isAndroid) {
        platformClientId =
            '174693600398-dnhnb2j1l6bhkl2g3r1goj7lcj3e53d8.apps.googleusercontent.com';
      } else {
        platformClientId = null;
      }

      // 구글 로그인 인스턴스 생성 및 초기화
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId:
            '174693600398-vng406q0u208sbnonb5hc3va8u9384u9.apps.googleusercontent.com',
        clientId: platformClientId,
      );

      // 구글 인증 UI를 통해 사용자 계정 정보 가져오기
      final user = await googleSignIn.authenticate();

      // 사용자 정보가 Null이면 즉시 오류 처리
      if (user == null) {
        throw AuthException(
          'Failed to sign in with Google or sign in cancelled.',
        );
      }
      _googleUser = user; // 널 체크 후 _googleUser에 할당

      final authorization = await _googleUser!.authorizationClient
          .authorizationForScopes(scopes)
          .catchError((_) async {
            // 첫 번째 시도가 실패하면 authorizeScopes로 다시 시도
            return await _googleUser!.authorizationClient.authorizeScopes(
              scopes,
            );
          });

      // Supabase 인증에 필요한 ID 토큰 가져오기
      final idToken = _googleUser!.authentication.idToken;

      if (idToken == null) {
        throw AuthException(
          'No ID Token found after successful Google sign-in.',
        );
      }

      // ID 토큰을 사용하여 Supabase에 로그인
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization?.accessToken,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_login', isAutoLogin);

      // 로그인 후 프로필 확인 및 화면 이동 로직 처리
      await _handlePostSignIn(context);
    } catch (e) {
      // TODO: 나중에 스낵바 제거
      // 오류 발생 시 스낵바로 오류 메시지 표시
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 처리 중 오류 발생: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        GoRouter.of(context).pop();
      }
    } finally {
      // 로딩 인디케이터 닫기
      if (context.mounted) {
        // Pop하기 전에 context가 여전히 화면에 마운트되어 있는지 다시 확인
        if (ModalRoute.of(context)?.isCurrent == true) {
          GoRouter.of(context).pop();
        }
      }
    }
  }

  // 로그인 성공 후 공통 로직을 처리하는 함수
  Future<void> _handlePostSignIn(BuildContext context) async {
    // 현재 Supabase에 로그인된 사용자 정보 가져오기
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      throw AuthException('Failed to get user from Supabase.');
    }

    try {
      // 'users' 테이블에서 현재 사용자 ID와 일치하는 프로필 정보 조회
      final response = await supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .maybeSingle();

      // 위젯이 화면에 마운트되어 있는지 확인
      if (!context.mounted) return;

      // 프로필 정보가 없으면 (신규 사용자) 회원가입 화면으로 이동
      if (response == null) {
        GoRouter.of(context).go('/signup');
      } else {
        // 데이터 가져오기
        try {
          final calendars = await SupabaseManager.shared.getCalendars();
          final tasks = await SupabaseManager.shared.getTasks();
        } catch (e) {}

        // 프로필 정보가 있으면 (기존 사용자) 로그인 성공 스낵바 표시 후 메인 화면으로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 성공하였습니다.'),
            backgroundColor: Colors.green,
          ),
        );
        GoRouter.of(context).go('/shared');
      }
    } catch (e) {
      // 오류 발생 시 스낵바로 오류 메시지 표시
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('프로필 확인 중 오류 발생: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
