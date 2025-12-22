import 'package:dutytable/features/notification/data/datasources/notification_data_source.dart';
import 'package:dutytable/features/notification/data/models/invite_notification_model.dart';
import 'package:flutter/material.dart';

class InvitationDialog extends StatefulWidget {
  const InvitationDialog({
    super.key,
    required this.notification,
  });

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
        Navigator.of(context).pop(true); // 수락 성공
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        Navigator.of(context).pop(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초대 수락 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _onHold() {
    Navigator.of(context).pop(false); // 보류
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('그룹 캘린더 초대'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Text('그룹 캘린더 초대가 도착했습니다.'),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : _onHold,
          child: const Text('보류'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _onAccept,
          child: const Text('수락'),
        ),
      ],
    );
  }
}
