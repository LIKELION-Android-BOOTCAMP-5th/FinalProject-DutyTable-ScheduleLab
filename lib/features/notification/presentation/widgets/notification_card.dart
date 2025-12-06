import 'package:dutytable/extensions.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  /// 알림 제목
  final String title;

  /// 알림 타입 - 초대 / 리마인더
  final String type;

  /// 알림 생성일
  final DateTime createdAt;

  /// 알림 카드
  const NotificationCard({
    super.key,
    required this.title,
    required this.type,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(1.95, 1.95),
            blurRadius: 2.6,
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: type == "invite" ? Color(0xff3c82f6) : Color(0xffa855f7),
              borderRadius: BorderRadius.circular(12),
            ),
            width: deviceWidth,
            height: 80,
          ),
          Positioned(
            right: 0,
            child: Container(
              width: deviceWidth * 0.91,
              height: 80,
              decoration: BoxDecoration(
                color: type == "invite" ? Color(0xffd7e6f8) : Color(0xfffaf5ff),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    createdAt.timeAgo(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
