import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DioClient {
  static final DioClient _shared = DioClient._internal();
  static DioClient get shared => _shared;

  static const String _baseUrl = 'https://eexkppotdipyrzzjakur.supabase.co';
  static final String _apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  late final Dio _dio;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {'apikey': _apiKey, 'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final session = Supabase.instance.client.auth.currentSession;
          final accessToken = session?.accessToken;

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
