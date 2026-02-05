import 'dart:async';

import 'package:dutytable/features/calendar/domain/usecases/read_calendar_title_by_id_use_case.dart';
import 'package:dutytable/features/calendar/domain/usecases/read_shared_calendar_from_id_use_case.dart';
import 'package:dutytable/features/notification/domain/usecases/setup_realtime_listeners_use_case.dart';
import 'package:dutytable/features/notification/domain/usecases/stream_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/invite_notification_model.dart';
import '../../data/models/reminder_notification_model.dart';
import '../../domain/usecases/delete_all_notifications_use_case.dart';
import '../../domain/usecases/has_unread_notifications_use_case.dart';
import '../../domain/usecases/mark_reminder_as_read_use_case.dart';

@injectable
class NavigationTarget {
  final String route;
  final Object? extra;
  const NavigationTarget(this.route, {this.extra});
}

@injectable
class NotificationViewModel with ChangeNotifier {
  final ReadCalendarTitleByIdUseCase _readCalendarTitleByIdUseCase;
  final ReadSharedCalendarFromIdUseCase _readSharedCalendarFromIdUseCase;
  final SetupRealtimeListenersUseCase _setupRealtimeListenersUseCase;
  final DeleteAllNotificationsUseCase _deleteAllNotificationsUseCase;
  final MarkReminderAsReadUseCase _markReminderAsReadUseCase;
  final HasUnreadNotificationsUseCase _hasUnreadNotificationsUseCase;
  final StreamUseCase _streamUseCase;

  bool _isLoading = true;
  List<dynamic> _notifications = [];

  StreamSubscription? _inviteSubscription;
  StreamSubscription? _reminderSubscription;

  /// Invite 알림에 보여줄 캘린더 제목
  Map<int, String> calendarTitles = {};

  bool get isLoading => _isLoading;
  List<dynamic> get notifications => _notifications;

  NotificationViewModel(
    this._setupRealtimeListenersUseCase,
    this._deleteAllNotificationsUseCase,
    this._markReminderAsReadUseCase,
    this._hasUnreadNotificationsUseCase,
    this._streamUseCase,
    this._readCalendarTitleByIdUseCase,
    this._readSharedCalendarFromIdUseCase,
  ) {
    loadInitialNotifications();
    setupRealtimeListeners();
  }

  Future<void> loadInitialNotifications() async {
    try {
      final combinedList = await _hasUnreadNotificationsUseCase();

      // Invite 알림에 필요한 캘린더 제목 프리패치
      final titleFutures = <Future<void>>[];
      for (final n in combinedList) {
        if (n is InviteNotificationModel) {
          titleFutures.add(
            _readCalendarTitleByIdUseCase(n.calendarId)
                .then((title) => calendarTitles[n.calendarId] = title)
                .catchError((_) {}),
          );
        }
      }
      await Future.wait(titleFutures);

      // 최신순 정렬
      combinedList.sort((a, b) {
        final dateA = a.createdAt as DateTime;
        final dateB = b.createdAt as DateTime;
        return dateB.compareTo(dateA);
      });

      _notifications = combinedList;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setupRealtimeListeners() {
    _setupRealtimeListenersUseCase();

    _inviteSubscription = _streamUseCase.inviteStream.listen((notification) {
      _notifications.insert(0, notification);
      notifyListeners();
    });

    _reminderSubscription = _streamUseCase.reminderStream.listen((
      notification,
    ) {
      _notifications.insert(0, notification);
      notifyListeners();
    });
  }

  /// 전체삭제
  Future<void> deleteAllNotifications() async {
    await _deleteAllNotificationsUseCase();
    _notifications.clear();
    notifyListeners();
  }

  /// 안 읽은 알림 존재 여부 계산
  Future<bool> hasUnreadNotifications() async {
    final inviteremiderFuture = _hasUnreadNotificationsUseCase();
    final results = await Future.wait([inviteremiderFuture]);

    return [...results[0], ...results[1]].any((n) {
      if (n is InviteNotificationModel) return n.isRead == false;
      if (n is ReminderNotificationModel) return n.isRead == false;
      return false;
    });
  }

  Future<NavigationTarget> resolveCalendarTarget(int calendarId) async {
    final targetCalendar = await _readSharedCalendarFromIdUseCase(calendarId);

    if (targetCalendar.type == 'group') {
      return NavigationTarget('/shared/schedule', extra: targetCalendar);
    }
    return const NavigationTarget('/personal');
  }

  /// 리마인더 읽음 처리
  Future<void> markReminderAsRead(
    ReminderNotificationModel notification,
  ) async {
    if (notification.isRead) return;

    await _markReminderAsReadUseCase(notification.id, 'remider');
    notification.isRead = true;

    notifyListeners();
  }

  @override
  void dispose() {
    _inviteSubscription?.cancel();
    _reminderSubscription?.cancel();
    super.dispose();
  }
}
