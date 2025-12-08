import 'package:dutytable/features/calendar/presentation/views/add_calendar_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/calendar_edit_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/personal/personal_calendar_screen.dart';
import 'package:dutytable/features/notification/presentation/views/notification_screen.dart';
import 'package:dutytable/features/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// UI
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/signup_screen.dart';
import '../../features/calendar/presentation/views/calendar_setting_screen.dart';
import '../../features/calendar/presentation/views/shared/shared_calendar_list_screen.dart';
import 'app_shell.dart';

GoRouter createRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/shared',
    routes: [
      // 로그인
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

      // 회원가입
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),

      // 공유 캘린더 - 캘린더 추가
      GoRoute(
        path: '/shared/add',
        builder: (_, __) => const AddCalendarScreen(),
      ),

      GoRoute(
        path: '/calendar/setting',
        builder: (_, __) => const CalendarSettingScreen(),
      ),

      GoRoute(
        path: '/calendar/edit',
        builder: (_, __) => const CalendarEditScreen(),
      ),

      // 공유 캘린더 - 알림
      GoRoute(
        path: '/notification',
        builder: (_, __) => const NotificationScreen(),
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
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
}
