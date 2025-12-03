import 'package:dutytable/features/calendar/presentation/views/add_calendar_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/personal/personal_calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';

// UI
import '../../features/calendar/presentation/views/shared/shared_calendar_list_screen.dart';

GoRouter createRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/shared',
    routes: [
      // 공유 캘린더 - 캘린더 추가
      GoRoute(
        path: '/shared/add',
        builder: (_, __) => const AddCalendarScreen(),
      ),

      // 바텀 네비게이션
      ShellRoute(
        builder: (_, _, child) => AppShell(child: child),
        routes: [
          // 공유 캘린더
          GoRoute(
            path: '/shared',
            builder: (_, __) => const SharedCalendarListScreen(),
          ),

          // 내 캘린더
          GoRoute(
            path: '/personal',
            builder: (_, __) => const PersonalCalendarScreen(),
          ),

          // 프로필
          // GoRoute(path: '/profile', builder: null),
        ],
      ),
    ],
  );
}
