import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  GoogleSignInAccount? _googleUser;
  GoogleSignInAccount? get googleUser => _googleUser;

  // 로그인
  Future<User?> googleSignIn(BuildContext context) async {
    final scopes = ['email', 'profile'];

    // 구글 프로바이더 작동
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId:
          '362604763800-rv6sptqta996r3hsv69jt7cb3o1pg7ru.apps.googleusercontent.com',
    );
    // 구글 프로바이더 작동

    // 구글에서 유저 정보 _googleUser로 전달
    _googleUser = await googleSignIn.authenticate();
    // 구글에서 유저 정보 _googleUser로 전달

    // 구글 계정 없음
    if (_googleUser == null) {
      return null;
    }
    // 구글 계정 없음

    // 토큰 발급 과정?
    final authorization =
        await _googleUser?.authorizationClient.authorizationForScopes(scopes) ??
        await _googleUser?.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser?.authentication.idToken;

    if (idToken == null) {
      return null;
    }

    // Firebase로 인증
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: authorization?.accessToken,
      idToken: idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);

    print("userCredential.user : ${userCredential.user}");
    return userCredential.user;
  }
}
