import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/core/widgets/custom_confirm_dialog.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/calendar/presentation/widgets/member_invite_dialog/invitation_dialog.dart';
import 'package:dutytable/features/notification/presentation/viewmodels/notification_state.dart';
import 'package:dutytable/features/notification/presentation/viewmodels/notification_view_model.dart';
import 'package:dutytable/features/notification/presentation/widgets/all_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/invite_notification_model.dart';
import '../../data/models/reminder_notification_model.dart';
import '../widgets/notification_card.dart';

/// 알림 목록을 표시하고 관리하는 화면 위젯.
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: const _NotificationScreenUI(),
    );
  }
}

class _NotificationScreenUI extends StatelessWidget {
  const _NotificationScreenUI();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: BackActionsAppBar(
        title: Text(
          "알림",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain(context),
          ),
        ),
        actions: [
          if (!viewModel.isLoading && viewModel.notifications.isNotEmpty)
            GestureDetector(
              onTap: () async {
                await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => ChangeNotifierProvider.value(
                    value: context.read<NotificationViewModel>(),
                    child: const AllDeleteDialog(),
                  ),
                );
              },
              child: Text(
                "전체삭제",
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: NotificationBody(viewModel: viewModel),
      ),
    );
  }
}

class NotificationBody extends StatelessWidget {
  final NotificationViewModel viewModel;

  const NotificationBody({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary(context)),
      );
    }

    if (viewModel.notifications.isEmpty) {
      return Center(
        child: Text(
          '새로운 알림이 없습니다.',
          style: TextStyle(color: AppColors.textSub(context)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: viewModel.notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notification = viewModel.notifications[index];

        return GestureDetector(
          onTap: () async {
            try {
              // ---- Invite 알림 ----
              if (notification is InviteNotificationModel) {
                if (notification.is_accepted) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('이미 수락된 초대입니다.')),
                  );
                  return;
                }

                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => ChangeNotifierProvider.value(
                    value: viewModel,
                    child: InvitationDialog(notification: notification),
                  ),
                );

                if (result == true) {
                  try {
                    context.read<SharedCalendarViewModel>().fetchCalendars();
                  } catch (_) {}

                  final target =
                  await viewModel.resolveCalendarTarget(notification.calendarId);

                  if (!context.mounted) return;
                  context.go(target.route, extra: target.extra);
                } else {
                  // 초대 다이얼로그 닫힘/취소면 리스트 갱신
                  await viewModel.loadInitialNotifications();
                }
                return;
              }

              // ---- Reminder 알림 ----
              if (notification is ReminderNotificationModel) {
                // 읽음 처리: VM 동작만 호출 (UI는 탭 흐름만 관리)
                try {
                  await viewModel.markReminderAsRead(notification);
                } catch (_) {
                  // 읽음 처리 실패는 다음 단계에서 UI 스낵바 처리로 확장 가능
                }

                final target =
                await viewModel.resolveCalendarTarget(notification.calendarId);

                if (!context.mounted) return;
                context.go(target.route, extra: target.extra);
                return;
              }
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('처리 중 오류가 발생했습니다: $e')),
              );
            }
          },
          child: () {
            if (notification is InviteNotificationModel) {
              final title =
                  viewModel.calendarTitles[notification.calendarId] ?? '';
              return NotificationCard(
                title: title,
                createdAt: notification.createdAt,
                type: "invite",
                isRead: notification.isRead,
                isAccepted: notification.is_accepted,
              );
            } else if (notification is ReminderNotificationModel) {
              return NotificationCard(
                title: notification.firstMessage,
                createdAt: notification.createdAt,
                type: "reminder",
                isRead: notification.isRead,
              );
            }
            return const SizedBox.shrink();
          }(),
        );
      },
    );
  }
}
