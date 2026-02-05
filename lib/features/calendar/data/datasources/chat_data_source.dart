import 'package:dio/dio.dart';
import 'package:dutytable/main.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_manager.dart';

@lazySingleton
class ChatDataSource {
  ChatDataSource(this._dio);
  final Dio _dio;

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
        'calendar_id': 'eq.$calendarId',
      },
      data: payload,
    );
  }

  /// READ
  RealtimeChannel subscribeToMessages(
    int calendarId,
    Function(Map<String, dynamic>) onMessage,
  ) {
    return SupabaseManager.shared.supabase
        .channel('chatting')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'calendar_id',
            value: calendarId,
          ),
          callback: (payload) {
            onMessage(payload.newRecord);
          },
        )
        .subscribe();
  }

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

  // 안읽은 채팅 수
  Future<int> readUnreadChatCount(int calendarId, String userId) async {
    try {
      final memberResponse = await _dio.get(
        '/rest/v1/calendar_members',
        queryParameters: {
          'select': 'last_read_at',
          'calendar_id': 'eq.$calendarId',
          'user_id': 'eq.$userId',
        },
      );

      if (memberResponse.data == null || memberResponse.data.isEmpty) {
        return 0;
      }

      final lastReadAt = memberResponse.data[0]['last_read_at'] as String?;

      if (lastReadAt == null) {
        return 0;
      }

      final messagesResponse = await _dio.get(
        '/rest/v1/chat_messages',
        queryParameters: {
          'calendar_id': 'eq.$calendarId',
          'created_at': 'gt.$lastReadAt',
          'select': 'count',
        },
      );

      if (messagesResponse.data is List && messagesResponse.data.isNotEmpty) {
        return messagesResponse.data[0]['count'] as int? ?? 0;
      }

      return 0;
    } catch (e) {
      print('Error loading unread count: $e');
      return 0;
    }
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
