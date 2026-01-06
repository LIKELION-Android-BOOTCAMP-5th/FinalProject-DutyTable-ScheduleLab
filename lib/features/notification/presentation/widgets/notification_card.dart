import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/utils/extensions.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  /// 알림 제목
  final String title;

  /// 알림 타입 - 초대 / 리마인더
  final String type;

  /// 알림 생성일
  final DateTime createdAt;

  /// 알림 읽음 여부
  final bool isRead;

  /// 초대 수락 여부 (초대 알림에만 해당)
  final bool? isAccepted;

  /// 알림 카드
  const NotificationCard({
    super.key,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.isAccepted,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.notificationCardBg(
                context,
                type: type,
                isRead: isRead,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            width: deviceWidth,
            height: 80,
          ),
          Positioned(
            right: 2,
            child: Container(
              width: deviceWidth * 0.9,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.notificationCardPoint(
                  context,
                  type: type,
                  isRead: isRead,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        type == "invite"
                            ? '"$title" 그룹 캘린더 초대가 도착했습니다.'
                            : title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMain(context),
                        ),
                      ),
                      if (type == "invite")
                        Text(
                          isAccepted == true ? " (수락됨)" : " (대기중)",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dTextSub,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    createdAt.timeAgo(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColors.textMain(context),
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
