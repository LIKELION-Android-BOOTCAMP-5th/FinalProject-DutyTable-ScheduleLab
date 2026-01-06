import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:dutytable/main.dart';

class ProfileDataSource {
  ProfileDataSource._();

  static final ProfileDataSource instance = ProfileDataSource._();

  final Dio _dio = DioClient.shared.dio;

  /// UPDATE
  // 닉네임, 구글연동, 알림, 수파베이스에 이미지 저장
  Future<void> updateUserProfile({
    required String userId,
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
  Future<void> deleteUser(String userId) async {
    await _dio.delete('/rest/v1/users', queryParameters: {'id': 'eq.$userId'});
    try {
      final String bucketName = 'profile-images';
      final imageFile = await supabase.storage
          .from(bucketName)
          .list(path: userId); // List<FileObject> 형식이라서
      final filePaths = imageFile
          .map((file) => '$userId/${file.name}')
          .toList(); // List<String> 형식으로 바꿔줌
      await supabase.storage.from(bucketName).remove(filePaths);
      print('이미지 삭제 성공!!!!!!');
    } catch (e) {
      print('이미지 삭제 중 오류 발생: $e');
    }
  }

  /// READ
  // 닉네임, 이메일, 프사 가져오기
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final currentUserId = supabase.auth.currentUser?.id;
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'nickname,email,profile_url,is_google_calendar_connect',
        'id': 'eq.$currentUserId',
        'limit': 1,
      },
    );
    return response.data[0] as Map<String, dynamic>;
  }

  // 닉네임 중복 검사
  Future<bool> isDuplicateNickname(editingNickname) async {
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
