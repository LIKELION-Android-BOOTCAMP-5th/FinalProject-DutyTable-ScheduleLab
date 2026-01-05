import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthDataSource {
  final SupabaseClient supabase;

  AuthDataSource({SupabaseClient? supabaseClient})
      : supabase = supabaseClient ?? Supabase.instance.client;

  GoogleSignInAccount? _googleUser;
  GoogleSignInAccount? get googleUser => _googleUser;

  String _env(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('Missing .env key: $key');
    }
    return value;
  }

  /// Google 로그인 + Supabase Auth
  Future<void> signInWithGoogle() async {
    final scopes = ['email', 'profile'];

    final String? platformClientId;
    if (Platform.isIOS) {
      platformClientId = _env('GOOGLE_IOS_CLIENT_ID');
    } else if (Platform.isAndroid) {
      platformClientId = _env('GOOGLE_ANDROID_CLIENT_ID');
    } else {
      platformClientId = null;
    }

    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId: _env('GOOGLE_SERVER_CLIENT_ID'),
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
