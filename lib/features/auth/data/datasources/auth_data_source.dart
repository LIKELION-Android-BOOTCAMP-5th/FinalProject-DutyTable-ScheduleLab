import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSource {
  final SupabaseClient supabase;

  AuthDataSource({SupabaseClient? supabaseClient})
      : supabase = supabaseClient ?? Supabase.instance.client;

  GoogleSignInAccount? _googleUser;
  GoogleSignInAccount? get googleUser => _googleUser;

  /// Google 로그인 + Supabase Auth
  Future<void> signInWithGoogle() async {
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

    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId:
      '174693600398-vng406q0u208sbnonb5hc3va8u9384u9.apps.googleusercontent.com',
      clientId: platformClientId,
    );

    final user = await googleSignIn.authenticate();
    if (user == null) {
      throw const AuthException('Google sign-in cancelled.');
    }
    _googleUser = user;

    final authorization = await _googleUser!.authorizationClient
        .authorizationForScopes(scopes)
        .catchError((_) async {
      return await _googleUser!.authorizationClient.authorizeScopes(scopes);
    });

    final idToken = _googleUser!.authentication.idToken;
    if (idToken == null) {
      throw const AuthException('No ID Token from Google.');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization?.accessToken,
    );
  }

  /// Apple 로그인 + Supabase Auth
  Future<void> signInWithApple() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException('No ID Token from Apple credential.');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }
}
