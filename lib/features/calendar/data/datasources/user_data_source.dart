import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../main.dart';

class UserDataSource {
  UserDataSource._internal() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final session = supabase.auth.currentSession;

          if (session?.accessToken != null) {
            options.headers['Authorization'] = 'Bearer ${session!.accessToken}';
          }

          handler.next(options);
        },
        onError: (e, handler) {
          debugPrint('❌ Dio Error: ${e.response?.statusCode}');
          debugPrint('❌ Dio Error Body: ${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }

  /// 싱글턴
  static final UserDataSource _shared = UserDataSource._internal();
  static UserDataSource get shared => _shared;

  static const String _baseUrl = 'https://eexkppotdipyrzzjakur.supabase.co';
  static final String apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'apikey': apiKey, 'Content-Type': 'application/json'},
    ),
  );

  /// 닉네임으로 유저 조회
  Future<Map<String, String>?> findUserByNickname(String nickname) async {
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'id,nickname',
        'nickname': 'eq.$nickname',
        'limit': 1,
      },
    );

    final data = response.data as List;

    if (data.isEmpty) return null;

    final user = data.first as Map<String, dynamic>;

    return {'id': user['id'] as String, 'nickname': user['nickname'] as String};
  }
}
