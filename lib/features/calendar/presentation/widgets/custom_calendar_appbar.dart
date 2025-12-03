import 'package:flutter/material.dart';

class CustomCalendarAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  /// 커스텀 캘린더 앱바
  const CustomCalendarAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
      actions: <Widget>[
        //TODO : 공유 캘린더만 초대 아이콘 나오게 하기
        // 커스텀 캘린더 앱바 아이콘 사용
        CustomAppBarIcon(icon: Icons.person_add, debugComment: "초대 클릭"),
        // 커스텀 캘린더 앱바 아이콘 사용
        CustomAppBarIcon(icon: Icons.notifications, debugComment: "알림 클릭"),
        // 커스텀 캘린더 앱바 아이콘 사용
        CustomAppBarIcon(icon: Icons.menu, debugComment: "매뉴 클릭"),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarIcon extends StatelessWidget {
  /// 아이콘
  final IconData icon;

  /// 디버깅 커멘트
  final String debugComment;

  /// 커스텀 캘린더 앱바 아이콘
  const CustomAppBarIcon({
    super.key,
    required this.icon,
    required this.debugComment,
  });

  @override
  Widget build(BuildContext context) {
    //TODO: GestureDetector or IconButton 선택
    // 리플 없는 버튼
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
    // 리플 있는 버튼
    return IconButton(
      onPressed: () {
        print(debugComment);
      },
      icon: Icon(icon, size: 28),
    );
  }
}
