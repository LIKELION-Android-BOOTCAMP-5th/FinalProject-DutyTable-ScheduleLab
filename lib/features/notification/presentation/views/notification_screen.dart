import 'dart:async';

import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../calendar/data/datasources/calendar_data_source.dart';
import '../../data/datasources/notification_data_source.dart';
import '../../data/models/invite_notification_model.dart';
import '../../data/models/reminder_notification_model.dart';
import '../widgets/all_delete_dialog.dart';
import '../widgets/notification_card.dart';

/// 알림 목록을 표시하고 관리하는 화면 위젯.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

/// [NotificationScreen]의 상태를 관리하는 클래스.
/// 알림 데이터를 로드하고 실시간 스트림을 구독하며, UI 업데이트를 처리
class _NotificationScreenState extends State<NotificationScreen> {
  // 데이터 로딩 중인지 여부를 나타내는 플래그
  bool _isLoading = true;
  // 현재 표시될 알림 목록 (초대 알림과 리마인더 알림을 모두 포함)
  List<dynamic> _notifications = [];
  // 초대 알림 스트림 구독을 관리하는 객체
  StreamSubscription? _inviteSubscription;
  // 리마인더 알림 스트림 구독을 관리하는 객체
  StreamSubscription? _reminderSubscription;

  /// 위젯이 생성될 때 호출되는 초기화 메서드
  /// 초기 알림을 로드하고 실시간 리스너를 설정
  @override
  void initState() {
    super.initState();
    _loadInitialNotifications(); // 화면 진입 시 기존 알림 로드
    _setupRealtimeListeners(); // 실시간 알림 수신을 위한 리스너 설정
  }

  /// 위젯이 소멸될 때 호출되는 정리 메서드.
  /// 메모리 누수를 방지하기 위해 스트림 구독 취소
  @override
  void dispose() {
    _inviteSubscription?.cancel(); // 초대 알림 스트림 구독 취소
    _reminderSubscription?.cancel(); // 리마인더 알림 스트림 구독 취소
    super.dispose();
  }

  /// Supabase에서 초기 알림 목록을 비동기적으로 로드
  /// 초대 알림과 리마인더 알림을 모두 가져와 합친 후, 최신순으로 정렬
  Future<void> _loadInitialNotifications() async {
    try {
      final inviteFuture = NotificationDataSource.shared.getInviteNotifications();
      final reminderFuture = NotificationDataSource.shared.getReminderNotifications();

      final results = await Future.wait([inviteFuture, reminderFuture]);

      final List<dynamic> combinedList = [...results[0], ...results[1]];

      combinedList.sort((a, b) {
        final dateA = a.createdAt as DateTime;
        final dateB = b.createdAt as DateTime;
        return dateB.compareTo(dateA); // 내림차순 정렬 (최신 알림이 위로)
      });

      // 위젯이 마운트된 상태일 때만 UI를 업데이트
      if (mounted) {
        setState(() {
          _notifications = combinedList; // 정렬된 알림 목록으로 상태 업데이트
          _isLoading = false; // 로딩 완료
        });
      }
    } catch (e) {
      // 에러 발생 시 로딩 상태 해제 및 에러 메시지 표시
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('알림을 불러오는 중 오류가 발생했습니다: $e')));
      }
    }
  }

  /// Supabase Realtime을 통해 실시간으로 들어오는 새로운 알림을 구독
  /// 새로운 알림이 수신되면 목록의 가장 위에 추가하고 UI를 업데이트
  void _setupRealtimeListeners() {
    // 초대 알림 스트림을 구독
    _inviteSubscription = NotificationDataSource.shared.newInviteNotifications.listen((
        notification,
        ) {
      // 위젯이 마운트된 상태일 때만 UI를 업데이트
      if (mounted) {
        setState(() {
          _notifications.insert(0, notification); // 새로운 알림을 목록의 맨 앞에 추가
        });
      }
    });

    // 리마인더 알림 스트림을 구독
    NotificationDataSource.shared.newReminderNotifications.listen((notification) {
      // 위젯이 마운트된 상태일 때만 UI를 업데이트
      if (mounted) {
        setState(() {
          _notifications.insert(0, notification); // 새로운 알림을 목록의 맨 앞에 추가
        });
      }
    });
  }

  /// '전체 삭제' 버튼 클릭 시 호출되는 로직.
  /// 사용자에게 삭제 확인 다이얼로그를 보여주고, 확인 시 모든 알림을 삭제
  void _handleDeleteAll() {
    showDialog<bool>(
      barrierDismissible: false, // 다이얼로그 외부 터치 시 닫히지 않음
      context: context,
      builder: (_) => AllDeleteDialog(), // 삭제 확인 다이얼로그 위젯
    ).then((confirmed) async {
      // 사용자가 '확인'을 눌렀을 경우
      if (confirmed == true) {
        try {
          await NotificationDataSource.shared
              .deleteAllNotifications(); // Supabase에서 모든 알림 삭제
          if (mounted) {
            setState(() {
              _notifications.clear(); // 로컬 알림 목록 비우기
            });
          }
        } catch (e) {
          // 삭제 중 에러 발생 시 스낵바 표시
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('알림 삭제 중 오류가 발생했습니다: $e')));
          }
        }
      }
    });
  }

  /// 위젯의 UI를 빌드
  /// 로딩 상태, 알림 없음 상태, 또는 알림 목록을 표시
  void _onNotificationTapped(dynamic notification) async {
    // 읽지 않은 상태일 때만 읽음 처리 실행
    if (!notification.isRead) {
      try {
        final type =
        notification is InviteNotificationModel ? 'invite' : 'reminder';
        await NotificationDataSource.shared.markAsRead(notification.id, type);
        setState(() {
          notification.isRead = true;
        });
      } catch (e) {
        // 읽음 처리 실패는 화면 이동을 막지 않음
        debugPrint('읽음 처리 실패: $e');
      }
    }

    // 캘린더 화면으로 이동
    try {
      final groupCalendarsFuture =
      CalendarDataSource.instance.fetchCalendarFinalList('group');
      final personalCalendarFuture =
      CalendarDataSource.instance.fetchPersonalCalendar();
      final results =
      await Future.wait([groupCalendarsFuture, personalCalendarFuture]);
      final groupCalendars = results[0] as List;
      final personalCalendar = results[1];
      final allCalendars = [...groupCalendars, personalCalendar];

      final targetCalendar = allCalendars.firstWhere(
            (c) => c.id == notification.calendarId,
        orElse: () => throw Exception('캘린더를 찾을 수 없습니다.'),
      );

      if (context.mounted) {
        if (targetCalendar.type == 'group') {
          context.go('/shared/schedule', extra: targetCalendar);
        } else {
          context.go('/personal');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('화면 이동 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackActionsAppBar(
        title: const Text(
          "알림",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
        ),
        actions: [
          if (!_isLoading && _notifications.isNotEmpty)
            GestureDetector(
              onTap: _handleDeleteAll,
              child: const Text(
                "전체삭제",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xfff9fafb),
          child: NotificationBody(
            isLoading: _isLoading,
            notifications: _notifications,
            onNotificationTapped: _onNotificationTapped,
          ),
        ),
      ),
    );
  }
}

class NotificationBody extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> notifications;
  final Function(dynamic) onNotificationTapped;

  const NotificationBody({
    super.key,
    required this.isLoading,
    required this.notifications,
    required this.onNotificationTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (notifications.isEmpty) {
      return const Center(
        child: Text('새로운 알림이 없습니다.', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return GestureDetector(
          onTap: () => onNotificationTapped(notification),
          child: () {
            if (notification is InviteNotificationModel) {
              return NotificationCard(
                title: notification.message,
                createdAt: notification.createdAt,
                type: "invite",
                isRead: notification.isRead,
              );
            } else if (notification is ReminderNotificationModel) {
              return NotificationCard(
                title: notification.firstMessage,
                createdAt: notification.createdAt,
                type: "reminder",
                isRead: notification.isRead,
              );
            }
            return Container();
          }(),
        );
      },
    );
  }
}
