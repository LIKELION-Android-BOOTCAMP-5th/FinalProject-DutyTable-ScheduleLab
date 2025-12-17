import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/invite_notification_model.dart';
import '../models/reminder_notification_model.dart';


class NotificationDataSource {
  static final NotificationDataSource _shared = NotificationDataSource();
  static NotificationDataSource get shared => _shared;

  // Supabase 클라이언트 참조
  final supabase = Supabase.instance.client;

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

  /// 과거 초대 알림 목록 가져오기
  Future<List<InviteNotificationModel>> getInviteNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await supabase
        .from('invite_notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => InviteNotificationModel.fromJson(json))
        .toList();
  }

  /// 과거 리마인더 알림 목록 가져오기
  Future<List<ReminderNotificationModel>> getReminderNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await supabase
        .from('reminder_notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ReminderNotificationModel.fromJson(json))
        .toList();
  }

  /// 모든 알림 삭제하기
  Future<void> deleteAllNotifications() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // 두 테이블에서 동시에 삭제
    await Future.wait([
      supabase.from('invite_notifications').delete().eq('user_id', userId),
      supabase.from('reminder_notifications').delete().eq('user_id', userId),
    ]);
  }

  /// 특정 알림을 읽음으로 표시
  Future<void> markAsRead(int notificationId, String type) async {
    final tableName =
    type == 'invite' ? 'invite_notifications' : 'reminder_notifications';
    await supabase
        .from(tableName)
        .update({'is_read': true}).eq('id', notificationId);
  }

  /// Realtime 알림 리스너 시작
  void startRealtimeListeners() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      debugPrint("인증된 사용자가 없어 실시간 리스너를 시작할 수 없습니다.");
      return;
    }

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
      callback: (payload) {
        debugPrint('초대 알림 변경 수신: ${payload.toString()}');
        final newRecord = payload.newRecord;
        final notification = InviteNotificationModel.fromJson(newRecord);
        _inviteNotificationController.sink.add(notification);
        debugPrint('새로운 초대 알림: ${notification.message}');
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
        debugPrint(
          '새로운 리마인더 알림: ${notification.firstMessage}',
        );
      },
    )
        .subscribe();

    debugPrint('실시간 리스너 시작 (사용자: $userId)');
  }

  /// Realtime 알림 리스너 중지
  Future<void> stopRealtimeListeners() async {
    // 채널 구독 해제
    if (_inviteNotificationChannel != null) {
      await supabase.removeChannel(_inviteNotificationChannel!);
    }
    if (_reminderNotificationChannel != null) {
      await supabase.removeChannel(_reminderNotificationChannel!);
    }
    _inviteNotificationChannel = null;
    _reminderNotificationChannel = null;
    debugPrint('실시간 리스너 중지됨.');
  }

  // SupabaseManager가 더 이상 필요 없을 때 StreamController 닫기 (메모리 누수 방지)
  void dispose() {
    _inviteNotificationController.close();
    _reminderNotificationController.close();
    stopRealtimeListeners(); // 폐기 전 리스너 중지 확인
  }
}
