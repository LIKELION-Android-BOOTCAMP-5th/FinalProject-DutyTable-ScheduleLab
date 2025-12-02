import 'package:flutter/material.dart';

class CalendarAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CalendarAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
      actions: <Widget>[
        //TODO : 공유 캘린더만 초대 아이콘 나오게 하기
        AppBarIcon(icon: Icons.person_add, debugComment: "초대 클릭"),
        AppBarIcon(icon: Icons.notifications, debugComment: "알림 클릭"),
        AppBarIcon(icon: Icons.menu, debugComment: "매뉴 클릭"),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// 캘린더 앱 바 아이콘 위젯
class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final String debugComment;
  const AppBarIcon({super.key, required this.icon, required this.debugComment});

  @override
  Widget build(BuildContext context) {
    /// GestureDetector or IconButton 선택
    // return GestureDetector(
    //   behavior: HitTestBehavior.opaque,
    //   onTap: () {
    //     print(debugComment);
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Icon(icon, size: 28),
    //   ),
    // );
    return IconButton(
      onPressed: () {
        print(debugComment);
      },
      icon: Icon(icon, size: 28),
    );
  }
}
