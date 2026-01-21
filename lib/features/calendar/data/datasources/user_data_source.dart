import 'package:dio/dio.dart';
import 'package:dutytable/features/calendar/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

import '../../../../main.dart';

@lazySingleton
class UserDataSource {
  UserDataSource() {
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

  static const String _baseUrl = 'https://eexkppotdipyrzzjakur.supabase.co';
  static final String apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {'apikey': apiKey, 'Content-Type': 'application/json'},
    ),
  );

  /// 닉네임으로 유저 검색 (초대용)
  Future<UserModel?> findUserByNickname(String nickname) async {
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'id,nickname,profile_url',
        'nickname': 'eq.$nickname',
        'limit': 1,
      },
    );

    final List<dynamic> data = response.data;
    if (data.isEmpty) return null;

    return UserModel.fromJson(data.first as Map<String, dynamic>);
  }

  /// 방장 이전
  Future<void> transferAdminRole(int calendarId, String newAdminId) async {
    final currentUserId = supabase.auth.currentUser!.id;

    // supabase function
    await supabase.rpc(
      'transfer_admin_role',
      params: {
        'p_calendar_id': calendarId,
        'p_new_admin_id': newAdminId,
        'p_old_admin_id': currentUserId,
      },
    );
  }

  /// 멤버 추방
  Future<void> exileMember(int calendarId, String userId) async {
    await _dio.delete(
      '/rest/v1/calendar_members',
      queryParameters: {
        'calendar_id': 'eq.$calendarId',
        'user_id': 'eq.$userId',
      },
    );
  }

  /// 단일 캘린더 나가기(내가 방장이 아닌 캘린더만)
  Future<void> outCalendar(int calendarId) async {
    final currentUser = supabase.auth.currentUser;
    await _dio.delete(
      '/rest/v1/calendar_members',
      queryParameters: {
        'calendar_id': 'eq.$calendarId',
        'is_admin': 'eq.false',
        'user_id': 'eq.${currentUser!.id}',
      },
    );
  }

  /// 다수의 캘린더 선택하여 나가기(삭제)(내가 방장이 아닌 캘린더들만)
  Future<void> outCalendars(List<int> calendarIds) async {
    final currentUser = supabase.auth.currentUser;
    await _dio.delete(
      '/rest/v1/calendar_members',
      queryParameters: {
        'calendar_id': 'in.(${calendarIds.join(",")})',
        'is_admin': 'eq.false',
        'user_id': 'eq.${currentUser!.id}',
      },
    );
  }

  /// 멤버 초대
  Future<void> inviteUsers(int calendarId, List<String> invitedUserIds) async {
    if (invitedUserIds.isNotEmpty) {
      final members = invitedUserIds
          .map((uid) => {'calendar_id': calendarId, 'user_id': uid})
          .toList();

      await _dio.post('/rest/v1/invite_notifications', data: members);
    }
  }

  /// 수파베이스에서 is_google_calendar_connection 정보 가져오기
  Future<bool> readIsGoogleCalendarConnection() async {
    final currentUserId = supabase.auth.currentUser?.id;
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'is_google_calendar_connect',
        'id': 'eq.$currentUserId',
        'limit': 1,
      },
    );
    return response.data[0]['is_google_calendar_connect'] as bool;
  }
}
