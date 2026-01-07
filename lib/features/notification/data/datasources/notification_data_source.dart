import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:dutytable/features/notification/presentation/viewmodels/notification_state.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/invite_notification_model.dart';
import '../models/reminder_notification_model.dart';

class NotificationDataSource {
  static final NotificationDataSource _shared = NotificationDataSource();
  static NotificationDataSource get shared => _shared;

  // Supabase 클라이언트 참조
  final supabase = Supabase.instance.client;
  final Dio _dio = DioClient.shared.dio;

  // 새로운 알림을 전달하기 위한 StreamController
  final _inviteNotificationController =
      StreamController<InviteNotificationModel>.broadcast();
  final _reminderNotificationController =
      StreamController<ReminderNotificationModel>.broadcast();

  // UI 컴포넌트가 리스닝할 공개 스트림
  Stream<InviteNotificationModel> get newInviteNotifications =>
      _inviteNotificationController.stream;
  Stream<ReminderNotificationModel> get newReminderNotifications =>
      _reminderNotificationController.stream;

  // 실시간 리스너를 관리하기 위한 RealtimeChannel
  RealtimeChannel? _inviteNotificationChannel;
  RealtimeChannel? _reminderNotificationChannel;

  NotificationDataSource() {
    debugPrint("NotificationDataSource init");
  }

  /// 알림 리스너와 초기 상태를 설정하는 통합 메서드
  Future<void> setupNotificationListenersAndState(BuildContext context) async {
    // context가 유효할 때만 provider를 읽어옴
    if (!context.mounted) return;
    final notificationState = context.read<NotificationState>();

    // 실시간 리스너 시작 및 구독
    startRealtimeListeners();
    newInviteNotifications.listen((_) {
      notificationState.setHasNewNotifications(true);
    });
    newReminderNotifications.listen((_) {
      notificationState.setHasNewNotifications(true);
    });

    // 기존 알림을 확인하여 초기 뱃지 상태 설정
    try {
      final inviteFuture = getInviteNotifications();
      final reminderFuture = getReminderNotifications();
      final results = await Future.wait([inviteFuture, reminderFuture]);
      final hasUnread = [
        ...results[0],
        ...results[1],
      ].any((n) => (n as dynamic).isRead == false);
      notificationState.setHasNewNotifications(hasUnread);
    } catch (e) {
      debugPrint("Failed to check initial notification status: $e");
    }
  }

  /// 과거 초대 알림 목록 가져오기
  Future<List<InviteNotificationModel>> getInviteNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _dio.get(
      '/rest/v1/invite_notifications',
      queryParameters: {
        'select': '*',
        'user_id': 'eq.$userId',
        'order': 'created_at.desc',
      },
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );

    return (response.data as List)
        .map((json) => InviteNotificationModel.fromJson(json))
        .toList();
  }

  /// 과거 리마인더 알림 목록 가져오기
  Future<List<ReminderNotificationModel>> getReminderNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await _dio.get(
      '/rest/v1/reminder_notifications',
      queryParameters: {
        'select': '*',
        'user_id': 'eq.$userId',
        'order': 'created_at.desc',
      },
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );

    return (response.data as List)
        .map((json) => ReminderNotificationModel.fromJson(json))
        .toList();
  }

  /// 특정 ID의 초대 알림 가져오기
  Future<InviteNotificationModel> getInviteNotificationById(
    int notificationId,
  ) async {
    final response = await _dio.get(
      '/rest/v1/invite_notifications',
      queryParameters: {'select': '*', 'id': 'eq.$notificationId', 'limit': 1},
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );

    if (response.data != null && (response.data as List).isNotEmpty) {
      return InviteNotificationModel.fromJson((response.data as List).first);
    } else {
      throw Exception('Notification not found');
    }
  }

  /// 모든 알림 삭제하기
  Future<void> deleteAllNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _dio.delete(
      '/rest/v1/invite_notifications',
      queryParameters: {'user_id': 'eq.$userId'},
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );

    await _dio.delete(
      '/rest/v1/reminder_notifications',
      queryParameters: {'user_id': 'eq.$userId'},
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );
  }

  /// 특정 알림을 읽음으로 표시
  Future<void> markAsRead(int notificationId, String type) async {
    final tableName = type == 'invite'
        ? 'invite_notifications'
        : 'reminder_notifications';
    await _dio.patch(
      '/rest/v1/$tableName',
      queryParameters: {'id': 'eq.$notificationId'},
      data: {'is_read': true},
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );
  }

  /// 초대 수락
  Future<void> acceptInvitation(InviteNotificationModel notification) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    // 사용자가 이미 멤버인지 확인
    final existingMemberResponse = await _dio.get(
      '/rest/v1/calendar_members',
      queryParameters: {
        'select': '*',
        'calendar_id': 'eq.${notification.calendarId}',
        'user_id': 'eq.$userId',
      },
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );

    // 멤버가 아닌 경우에만 추가
    if ((existingMemberResponse.data as List).isEmpty) {
      await _dio.post(
        '/rest/v1/calendar_members',
        data: {'calendar_id': notification.calendarId, 'user_id': userId},
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${supabase.auth.currentSession?.accessToken}',
          },
        ),
      );
    }

    // invite_notifications 테이블에서 is_accepted를 true로 업데이트하고 읽음 처리
    await _dio.patch(
      '/rest/v1/invite_notifications',
      queryParameters: {'id': 'eq.${notification.id}'},
      data: {'is_accepted': true, 'is_read': true},
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );
  }

  /// 초대 보류중인지 확인
  Future<bool> hasPendingInvite(int calendarId, String userId) async {
    final response = await _dio.get(
      '/rest/v1/invite_notifications',
      queryParameters: {
        'select': 'id',
        'calendar_id': 'eq.$calendarId',
        'user_id': 'eq.$userId',
        'is_read': 'eq.false',
        'limit': 1,
      },
      options: Options(
        headers: {
          'Authorization':
              'Bearer ${supabase.auth.currentSession?.accessToken}',
        },
      ),
    );

    return (response.data as List).isNotEmpty;
  }

  /// Realtime 알림 리스너 시작
  void startRealtimeListeners() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      debugPrint("인증된 사용자가 없어 실시간 리스너를 시작할 수 없습니다.");
      return;
    }

    // 기존 리스너가 있다면 중복 생성을 막기 위해 먼저 중지
    stopRealtimeListeners();

    // 초대 알림 채널 생성 및 구독
    _inviteNotificationChannel = supabase
        .channel('invite-notifications-channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'invite_notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) async {
            try {
              final newRecord = payload.newRecord;
              final notificationId = int.parse(newRecord['id'].toString());
              final notification = await getInviteNotificationById(
                notificationId,
              );
              _inviteNotificationController.sink.add(notification);
            } catch (e) {
              debugPrint('Error fetching full invitation from realtime: $e');
            }
          },
        )
        .subscribe();

    // 리마인더 알림 채널 생성 및 구독
    _reminderNotificationChannel = supabase
        .channel('reminder-notifications-channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'reminder_notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            debugPrint('리마인더 알림 변경 수신: ${payload.toString()}');
            final newRecord = payload.newRecord;
            final notification = ReminderNotificationModel.fromJson(newRecord);
            _reminderNotificationController.sink.add(notification);
            debugPrint('새로운 리마인더 알림: ${notification.firstMessage}');
          },
        )
        .subscribe();
  }

  /// Realtime 알림 리스너 중지
  Future<void> stopRealtimeListeners() async {
    // 채널 구독 해제
    if (_inviteNotificationChannel != null) {
      await supabase.removeChannel(_inviteNotificationChannel!);
      _inviteNotificationChannel = null;
    }
    if (_reminderNotificationChannel != null) {
      await supabase.removeChannel(_reminderNotificationChannel!);
      _reminderNotificationChannel = null;
    }
  }

  // SupabaseManager가 더 이상 필요 없을 때 StreamController 닫기 (메모리 누수 방지)
  void dispose() {
    _inviteNotificationController.close();
    _reminderNotificationController.close();
    stopRealtimeListeners(); // 폐기 전 리스너 중지 확인
  }
}
