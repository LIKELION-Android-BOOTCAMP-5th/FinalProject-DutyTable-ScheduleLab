import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/login_result_model.dart';

class UserDataSource {
  final SupabaseClient supabase;

  UserDataSource({SupabaseClient? supabaseClient})
    : supabase = supabaseClient ?? Supabase.instance.client;

  /// 닉네임 중복 체크
  Future<bool> isNicknameDuplicated(String nickname) async {
    final response = await supabase
        .from('users')
        .select('nickname')
        .eq('nickname', nickname)
        .limit(1)
        .maybeSingle();

    return response != null;
  }

  /// 회원가입 프로필 upsert
  Future<void> upsertUserProfile(Map<String, dynamic> updates) async {
    await supabase.from('users').upsert(updates);
  }

  /// 로그인 후 처리 (FCM 저장 + 신규/기존 판단)
  Future<LoginResultModel> postLoginProcess() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getAPNSToken();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      return LoginResultModel.fail('User not authenticated');
    }

    if (fcmToken != null) {
      await supabase
          .from('users')
          .update({'fcm_token': fcmToken})
          .eq('id', currentUser.id);
    }

    final profile = await supabase
        .from('users')
        .select('id')
        .eq('id', currentUser.id)
        .maybeSingle();

    if (profile == null) {
      return LoginResultModel.signup();
    }

    return LoginResultModel.shared();
  }

  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    final fileExtension = imageFile.path.split('.').last;
    final filePath = '$userId/profile.$fileExtension';

    await supabase.storage
        .from('profile-images')
        .upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    return supabase.storage.from('profile-images').getPublicUrl(filePath);
  }
}
