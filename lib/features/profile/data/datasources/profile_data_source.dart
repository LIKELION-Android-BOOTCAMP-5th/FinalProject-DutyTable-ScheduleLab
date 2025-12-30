import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:dutytable/main.dart';

class ProfileDataSource {
  ProfileDataSource._();

  static final ProfileDataSource instance = ProfileDataSource._();

  final Dio _dio = DioClient.shared.dio;

  /// UPDATE
  // 닉네임, 구글연동, 알림, 수파베이스에 이미지 저장
  Future<void> update({
    required userId,
    required Map<String, dynamic> payload,
  }) async {
    await _dio.patch(
      '/rest/v1/users',
      queryParameters: {'id': 'eq.$userId'},
      data: payload,
    );
  }

  /// DELETE
  // 회원탈퇴
  Future<void> deleteUser(userId) async {
    await _dio.delete('/rest/v1/users', queryParameters: {'id': 'eq.$userId'});
  }

  /// READ
  // 닉네임, 이메일, 프사 가져오기
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final currentUserId = supabase.auth.currentUser?.id;
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'nickname,email,profileurl,is_google_calendar_connect',
        'id': 'eq.$currentUserId',
        'limit': 1,
      },
    );
    return response.data[0] as Map<String, dynamic>;
  }

  // 닉네임 중복 검사
  Future<bool> fetchUserNickname(editingNickname) async {
    final currentUserId = supabase.auth.currentUser?.id;

    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'nickname',
        'nickname': 'eq.$editingNickname',
        'id': 'neq.$currentUserId',
      },
    );
    return (response.data.isEmpty) ? true : false;
  }
}
