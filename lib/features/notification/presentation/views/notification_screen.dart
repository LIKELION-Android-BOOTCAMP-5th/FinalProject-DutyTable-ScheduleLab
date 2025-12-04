import 'package:dutytable/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatelessWidget {
  /// 알림 화면
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
        child: Container(
          color: Color(0xfff9fafb),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _NotificataionCard(
                  title: "데이트 캘린더에 초대 받았습니다.",
                  createdAt: DateTime.now().subtract(Duration(minutes: 1)),
                  type: "invite",
                ),

                const SizedBox(height: 10),

                _NotificataionCard(
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

class _NotificataionCard extends StatelessWidget {
  /// 알림 제목
  final String title;

  /// 알림 타입 - 초대 / 리마인더
  final String type;

  /// 알림 생성일
  final DateTime createdAt;

  /// 알림 카드
  const _NotificataionCard({
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

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 알림 화면 앱 바
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          "알림",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) => _AllDeleteDialog(),
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
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AllDeleteDialog extends StatelessWidget {
  /// 알림 전체 삭제 다이얼로그
  const _AllDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.15)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "전체 알림을 삭제하시겠습니까?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xfff3f4f6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          "취소",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: GestureDetector(
                      /// TODO: 알림 전체(초대 및 리마인더) 삭제 API 연동 필요
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffef4444),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          "확인",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
