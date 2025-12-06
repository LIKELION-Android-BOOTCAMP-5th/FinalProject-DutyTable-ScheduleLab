import 'package:dutytable/core/widgets/back_actions_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/all_delete_dialog.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  /// 알림 화면
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 알림 화면 - 앱 바
      appBar: BackActionsAppBar(
        title: Text(
          "알림",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => AllDeleteDialog(),
              );
            },
            child: Text(
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

      // 알림 화면 - 알림 리스트
      body: SafeArea(
        child: Container(
          color: Color(0xfff9fafb),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                NotificationCard(
                  title: "데이트 캘린더에 초대 받았습니다.",
                  createdAt: DateTime.now().subtract(Duration(minutes: 1)),
                  type: "invite",
                ),

                const SizedBox(height: 10),

                NotificationCard(
                  title: "운동 캘린더 : 내일 헬스장 가기 일정이 있습니다.",
                  createdAt: DateTime.now().subtract(Duration(minutes: 4)),
                  type: "reminder",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
