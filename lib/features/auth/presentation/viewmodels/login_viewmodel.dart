import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';
import '../../../../supabase_user_model.dart';

class LoginViewModel extends ChangeNotifier {
  GoogleSignInAccount? _googleUser;

  GoogleSignInAccount? get googleUser => _googleUser;
  SupabaseUserModel? userAccount;

  // 로그인
  Future<void> googleSignIn(BuildContext context) async {
    final scopes = ['email', 'profile'];

    // 구글 프로바이더 작동
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId:
          '174693600398-vng406q0u208sbnonb5hc3va8u9384u9.apps.googleusercontent.com',
      clientId:
          '174693600398-dnhnb2j1l6bhkl2g3r1goj7lcj3e53d8.apps.googleusercontent.com',
    );

    // 구글에서 유저 정보 _googleUser로 전달
    _googleUser = await googleSignIn.authenticate();

    // 구글 계정 없음
    if (_googleUser == null) {
      throw AuthException('Failed to sign in with Google.');
    }

    // 토큰 발급 과정?
    final authorization =
        await _googleUser?.authorizationClient.authorizationForScopes(scopes) ??
        await _googleUser?.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser?.authentication.idToken;

    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization?.accessToken,
    );
    await _handlePostSignIn(context);
    // supabase public 테이블에 _googleUser로 받은 이메일이 있는지 확인
    // userAccount = await CoreDataSource.instance.fetchPublicUser(
    //   _googleUser!.email,
    // );
    // supabase public 테이블에 _googleUser로 받은 이메일이 있는지 확인

    // 리얼타임 채널 재구독
    // final alertViewModel = context.read<AlertProvider>();
    // alertViewModel.resubscribeRealtime();
    // 리얼타임 채널 재구독

    // if (userAccount != null) {
    //   alertViewModel.fetchAlerts();
    // }
  }

  // 로그인 후 공통 로직: 프로필 확인 및 화면 이동
  Future<void> _handlePostSignIn(BuildContext context) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      throw AuthException('Failed to get user from Supabase.');
    }

    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .maybeSingle();

      if (!context.mounted) return;

      if (response == null) {
        GoRouter.of(context).go('/signup');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 성공하였습니다.'),
            backgroundColor: Colors.green,
          ),
        );
        GoRouter.of(context).go('/shared');
      }
    } catch (e) {
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
