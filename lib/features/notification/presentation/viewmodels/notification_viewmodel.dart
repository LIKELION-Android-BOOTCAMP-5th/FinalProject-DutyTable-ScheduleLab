import 'dart:async';

import 'package:dutytable/features/notification/data/models/invite_notification_model.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_invite_dialog/invitation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../calendar/data/datasources/calendar_data_source.dart';
import '../../data/datasources/notification_data_source.dart';
import '../../data/models/reminder_notification_model.dart';
import 'notification_state.dart';

class NotificationViewModel with ChangeNotifier {
  bool _isLoading = true;
  List<dynamic> _notifications = [];
  StreamSubscription? _inviteSubscription;
  StreamSubscription? _reminderSubscription;

  bool get isLoading => _isLoading;
  List<dynamic> get notifications => _notifications;

  late BuildContext _context;

  NotificationViewModel(BuildContext context) {
    _context = context;
    loadInitialNotifications();
    setupRealtimeListeners();
  }

  Future<void> loadInitialNotifications() async {
    try {
      final inviteFuture =
      NotificationDataSource.shared.getInviteNotifications();
      final reminderFuture =
      NotificationDataSource.shared.getReminderNotifications();

      final results = await Future.wait([inviteFuture, reminderFuture]);

      final List<dynamic> combinedList = [...results[0], ...results[1]];

      combinedList.sort((a, b) {
        final dateA = a.createdAt as DateTime;
        final dateB = b.createdAt as DateTime;
        return dateB.compareTo(dateA);
      });

      _notifications = combinedList;
    } catch (e) {
      ScaffoldMessenger.of(_context)
          .showSnackBar(SnackBar(content: Text('알림을 불러오는 중 오류가 발생했습니다: $e')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setupRealtimeListeners() {
    _inviteSubscription = NotificationDataSource.shared.newInviteNotifications
        .listen((notification) {
      _notifications.insert(0, notification);
      notifyListeners();
    });

    _reminderSubscription =
        NotificationDataSource.shared.newReminderNotifications.listen(
              (notification) {
            _notifications.insert(0, notification);
            notifyListeners();
          },
        );
  }

  void handleDeleteAll() {
    CustomConfirmationDialog.show(
      _context,
      content: "정말 삭제하시겠습니까? \n 삭제된 알림은 \n 복구할 수 없습니다.",
      confirmColor: AppColors.danger(_context),
      confirmText: "삭제",
      cancelText: "취소",
      onConfirm: () async {
        try {
          await NotificationDataSource.shared.deleteAllNotifications();
          _notifications.clear();
          recheckUnreadNotificationsStatus();
          notifyListeners();
        } catch (e) {
          ScaffoldMessenger.of(_context)
              .showSnackBar(SnackBar(content: Text('알림 삭제 중 오류가 발생했습니다: $e')));
        }
      },
    );
  }

  void onNotificationTapped(dynamic notification) async {
    if (notification is InviteNotificationModel) {
      if (notification.is_accepted) {
        ScaffoldMessenger.of(_context)
            .showSnackBar(const SnackBar(content: Text('이미 수락된 초대입니다.')));
        return;
      }

      final result = await showDialog<bool>(
        context: _context,
        builder: (context) => InvitationDialog(notification: notification),
      );

      if (result == true) {
        _context.read<SharedCalendarViewModel>().fetchCalendars();
        await navigateToCalendar(notification.calendarId);
      } else {
        await loadInitialNotifications();
      }
    } else {
      if (!notification.isRead) {
        try {
          await NotificationDataSource.shared.markAsRead(
            notification.id,
            'reminder',
          );
          notification.isRead = true;
          notifyListeners();
        } catch (e) {
          // 에러 처리
        }
      }
      await navigateToCalendar(notification.calendarId);
    }
  }

  Future<void> navigateToCalendar(int calendarId) async {
    if (!_context.mounted) return;
    try {
      final targetCalendar = await CalendarDataSource.instance
          .fetchSharedCalendarFromId(calendarId);

      if (_context.mounted) {
        if (targetCalendar.type == 'group') {
          _context.go('/shared/schedule', extra: targetCalendar);
        } else {
          _context.go('/personal');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(_context)
          .showSnackBar(SnackBar(content: Text('화면 이동 중 오류가 발생했습니다: $e')));
    }
  }

  Future<void> recheckUnreadNotificationsStatus() async {
    try {
      final inviteFuture =
      NotificationDataSource.shared.getInviteNotifications();
      final reminderFuture =
      NotificationDataSource.shared.getReminderNotifications();
      final results = await Future.wait([inviteFuture, reminderFuture]);
      final hasUnread = [...results[0], ...results[1]].any((n) {
        if (n is InviteNotificationModel) {
          return n.isRead == false;
        } else if (n is ReminderNotificationModel) {
          return n.isRead == false;
        }
        return false;
      });
      if (_context.mounted) {
        _context.read<NotificationState>().setHasNewNotifications(hasUnread);
      }
    } catch (e) {
      debugPrint("Failed to re-check notification status: $e");
    }
  }

  @override
  void dispose() {
    _inviteSubscription?.cancel();
    _reminderSubscription?.cancel();
    recheckUnreadNotificationsStatus();
    super.dispose();
  }
}
