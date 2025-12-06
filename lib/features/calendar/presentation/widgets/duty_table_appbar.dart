import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// TODO
///  1. 라이트 모드 및 다크 모드 연결 필요
///  2. 현재 앱 바가 두개라 헷갈릴 수도 있음

class DutyTableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool deleteMode;
  final VoidCallback? onDeletePressed;

  /// 공유 캘린더 앱 바
  const DutyTableAppBar({
    super.key,
    required this.deleteMode,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
      ),
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1, // 굵기
          ),
        ),
      ),
      child: Row(
        children: [
          // LEFT: 로고 + 텍스트
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/calendar_logo.png",
                width: 60,
                height: 60,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 4),
              const Text(
                "DutyTable",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),

          const Spacer(),

          // RIGHT: 캘린더 추가, 알림, 캘린더 삭제
          deleteMode
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(onTap: onDeletePressed, child: Text("취소")),
                    const SizedBox(width: 16),
                    Text("삭제"),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3A7BFF),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () => context.push("/shared/add"),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),

                    const SizedBox(width: 16),

                    GestureDetector(
                      onTap: () => context.push("/notification"),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.notifications_none, size: 26),
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    GestureDetector(
                      onTap: onDeletePressed,
                      child: const Icon(Icons.delete_outline, size: 26),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
