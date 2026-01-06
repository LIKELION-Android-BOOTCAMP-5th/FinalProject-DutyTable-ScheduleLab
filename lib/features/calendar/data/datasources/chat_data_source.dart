import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:dutytable/main.dart';

class ChatDataSource {
  ChatDataSource._();

  static final ChatDataSource instance = ChatDataSource._();

  final Dio _dio = DioClient.shared.dio;

  /// UPDATE
  // last_read_at 업데이트
  Future<void> updateLastReadAt({
    required String userId,
    required int calendarId,
    required Map<String, dynamic> payload,
  }) async {
    await _dio.patch(
      '/rest/v1/calendar_members',
      queryParameters: {
        'user_id': 'eq.$userId',
        'calendar_id': 'eq.${calendarId}',
      },
      data: payload,
    );
  }

  /// READ
  // 모든 데이터를 한 번에 가져오는 함수로 통합
  Future<List<Map<String, dynamic>>> fetchChatMessages(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/chat_messages',
      queryParameters: {
        'select': 'id,message,created_at,user_id,users (profile_url,nickname)',
        'calendar_id': 'eq.$calendarId',
        'order': 'created_at.asc',
      },
    );
    return (response.data as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // 프사,닉네임 가져오기
  Future<Map<String, dynamic>> fetchNewChatImageNickname(String userId) async {
    // final currentUserId = supabase.auth.currentUser?.id;
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'nickname,profile_url',
        'id': 'eq.$userId',
        'limit': 1,
      },
    );
    return response.data[0] as Map<String, dynamic>;
  }

  /// CREATE
  // 채팅을 수파베이스에 저장
  Future<void> chatInsert(String chatMessage, int calendarId) async {
    final currentUserId = supabase.auth.currentUser?.id;
    try {
      await _dio.post(
        '/rest/v1/chat_messages',
        data: {
          'user_id': currentUserId,
          'calendar_id': calendarId,
          'message': chatMessage,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
    } catch (e) {
      throw Exception("create 에러:  $e");
    }
  }
}
