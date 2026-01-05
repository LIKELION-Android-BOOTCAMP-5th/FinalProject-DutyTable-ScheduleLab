import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/notification/data/datasources/notification_data_source.dart';
import 'package:dutytable/features/notification/data/models/invite_notification_model.dart';
import 'package:dutytable/features/notification/presentation/viewmodels/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InvitationDialog extends StatefulWidget {
  const InvitationDialog({super.key, required this.notification});

  final InviteNotificationModel notification;

  @override
  State<InvitationDialog> createState() => _InvitationDialogState();
}

class _InvitationDialogState extends State<InvitationDialog> {
  bool _isLoading = false;

  Future<void> _onAccept() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await NotificationDataSource.shared.acceptInvitation(widget.notification);
      if (mounted) {
        context.pop(true); // 수락 성공
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        context.pop(false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('초대 수락 중 오류가 발생했습니다: $e')));
      }
    }
  }

  void _onHold() async {
    try {
      await NotificationDataSource.shared
          .markAsRead(widget.notification.id, 'invite');
    } catch (e) {
      // 에러 처리
      debugPrint('알림 읽음 처리 중 오류 발생: $e');
    }
    if (mounted) {
      context.pop(false); // 보류
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          final calendarName =
              viewModel.calendarTitles[widget.notification.calendarId] ?? '';
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary(context),
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    '"$calendarName" 그룹 캘린더 초대가 도착했습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textMain(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      /// 취소 버튼
                      Expanded(
                        child: GestureDetector(
                          onTap: _isLoading ? null : _onHold,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.textSub(context),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "보류",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSub(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                  const SizedBox(width: 12),

                      /// 확인 버튼
                      Expanded(
                        child: GestureDetector(
                          onTap: _isLoading ? null : _onAccept,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primary(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                "수락",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
