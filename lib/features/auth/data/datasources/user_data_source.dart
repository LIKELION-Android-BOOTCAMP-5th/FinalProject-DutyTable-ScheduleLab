import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/login_result_model.dart';

@injectable
class UserDataSource {
  final SupabaseClient supabase;
  final Dio _dio;

  UserDataSource(this.supabase, this._dio);

  /// 닉네임 중복 체크 READ
  Future<bool> isNicknameDuplicated(String nickname) async {
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {'select': 'nickname', 'nickname': 'eq.$nickname'},
    );
    final data = response.data as List;
    return data.isNotEmpty;
  }

  /// 회원가입 프로필 upsert
  Future<void> upsertUserProfile(Map<String, dynamic> updates) async {
    await _dio.post(
      '/rest/v1/users',
      data: updates,
      options: Options(headers: {'Prefer': 'resolution=merge-duplicates'}),
    );
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

    // UPDATE
    if (fcmToken != null) {
      await _dio.patch(
        '/rest/v1/users',
        queryParameters: {'id': 'eq.${currentUser.id}'},
        data: {'fcm_token': fcmToken},
      );
    }

    // READ 얘가 문제
    final profile = await _dio.get(
      '/rest/v1/users',
      queryParameters: {'select': 'id', 'id': 'eq.${currentUser.id}'},
    );
    final data = profile.data as List;

    if (data.isEmpty) {
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
