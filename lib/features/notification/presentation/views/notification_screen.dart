import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:dutytable/features/notification/presentation/viewmodels/notification_viewmodel.dart';
import 'package:flutter/material.dart';
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
      create: (context) => NotificationViewModel(context),
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
              onTap: viewModel.handleDeleteAll,
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
        child: NotificationBody(
          isLoading: viewModel.isLoading,
          notifications: viewModel.notifications,
          onNotificationTapped: viewModel.onNotificationTapped,
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
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary(context)),
      );
    }
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          '새로운 알림이 없습니다.',
          style: TextStyle(color: AppColors.textSub(context)),
        ),
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
            return Container();
          }(),
        );
      },
    );
  }
}
