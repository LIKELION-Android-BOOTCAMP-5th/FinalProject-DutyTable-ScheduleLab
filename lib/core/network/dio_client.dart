import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final DioClient _shared = DioClient();
  static DioClient get shared => _shared;

  static const String _baseUrl = 'https://eexkppotdipyrzzjakur.supabase.co';

  static final String _apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'apikey': _apiKey, 'Content-Type': 'application/json'},
    ),
  );

  Dio get dio => _dio;
}
