import 'dart:async';

import 'package:flutter/material.dart';

import '../../../calendar/data/datasources/calendar_data_source.dart';
import '../../data/datasources/notification_data_source.dart';
import '../../data/models/invite_notification_model.dart';
import '../../data/models/reminder_notification_model.dart';

class NavigationTarget {
  final String route;
  final Object? extra;
  const NavigationTarget(this.route, {this.extra});
}

class NotificationViewModel with ChangeNotifier {
  bool _isLoading = true;
  List<dynamic> _notifications = [];

  StreamSubscription? _inviteSubscription;
  StreamSubscription? _reminderSubscription;

  /// Invite 알림에 보여줄 캘린더 제목
  Map<int, String> calendarTitles = {};

  bool get isLoading => _isLoading;
  List<dynamic> get notifications => _notifications;

  NotificationViewModel() {
    loadInitialNotifications();
    setupRealtimeListeners();
  }

  Future<void> loadInitialNotifications() async {
    try {
      final inviteFuture = NotificationDataSource.shared.getInviteNotifications();
      final reminderFuture = NotificationDataSource.shared.getReminderNotifications();

      final results = await Future.wait([inviteFuture, reminderFuture]);
      final List<dynamic> combinedList = [...results[0], ...results[1]];

      // Invite 알림에 필요한 캘린더 제목 프리패치
      final titleFutures = <Future<void>>[];
      for (final n in combinedList) {
        if (n is InviteNotificationModel) {
          titleFutures.add(
            CalendarDataSource.instance
                .getCalendarTitleById(n.calendarId)
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
    _inviteSubscription =
        NotificationDataSource.shared.newInviteNotifications.listen((notification) {
          _notifications.insert(0, notification);
          notifyListeners();
        });

    _reminderSubscription =
        NotificationDataSource.shared.newReminderNotifications.listen((notification) {
          _notifications.insert(0, notification);
          notifyListeners();
        });
  }

  /// 전체삭제
  Future<void> deleteAllNotifications() async {
    await NotificationDataSource.shared.deleteAllNotifications();
    _notifications.clear();
    notifyListeners();
  }

  /// 안 읽은 알림 존재 여부 계산
  Future<bool> hasUnreadNotifications() async {
    final inviteFuture = NotificationDataSource.shared.getInviteNotifications();
    final reminderFuture = NotificationDataSource.shared.getReminderNotifications();
    final results = await Future.wait([inviteFuture, reminderFuture]);

    return [...results[0], ...results[1]].any((n) {
      if (n is InviteNotificationModel) return n.isRead == false;
      if (n is ReminderNotificationModel) return n.isRead == false;
      return false;
    });
  }

  Future<NavigationTarget> resolveCalendarTarget(int calendarId) async {
    final targetCalendar =
    await CalendarDataSource.instance.fetchSharedCalendarFromId(calendarId);

    if (targetCalendar.type == 'group') {
      return NavigationTarget('/shared/schedule', extra: targetCalendar);
    }
    return const NavigationTarget('/personal');
  }

  /// 리마인더 읽음 처리
  Future<void> markReminderAsRead(ReminderNotificationModel notification) async {
    if (notification.isRead) return;

    await NotificationDataSource.shared.markAsRead(notification.id, 'reminder');
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
