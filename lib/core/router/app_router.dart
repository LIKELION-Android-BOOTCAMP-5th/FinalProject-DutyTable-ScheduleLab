import 'package:dutytable/features/calendar/presentation/views/add_calendar_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/calendar_edit_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/personal/personal_calendar_screen.dart';
import 'package:dutytable/features/schedule/presentation/views/schedule_detail_screen.dart';
import 'package:dutytable/features/notification/presentation/views/notification_screen.dart';
import 'package:dutytable/features/profile/presentation/views/profile_screen.dart';
import 'package:dutytable/features/schedule/presentation/views/schedule_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// UI
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/signup_screen.dart';
import '../../features/auth/presentation/views/splash_screen.dart';
import '../../features/calendar/data/models/calendar_model.dart';
import '../../features/calendar/presentation/views/calendar_setting_screen.dart';
import '../../features/calendar/presentation/views/shared/shared_calendar_list_screen.dart';
import 'app_shell.dart';

GoRouter createRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/personal',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
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
        builder: (context, state) {
          // 1. extra에서 데이터 추출 및 캐스팅 (CalendarModel 타입으로)
          final CalendarModel? calendarData = state.extra as CalendarModel?;

          // 2. CalendarSettingView에 데이터를 전달하여 ViewModel 초기화에 사용
          // 데이터를 받은 View를 리턴합니다.
          return CalendarSettingScreen(initialCalendarData: calendarData);
        },
      ),

      GoRoute(
        path: '/calendar/edit',
        builder: (context, state) {
          // 1. extra에서 데이터 추출 및 캐스팅 (CalendarModel 타입으로)
          final CalendarModel? calendarData = state.extra as CalendarModel?;
          // 2. CalendarSettingView에 데이터를 전달하여 ViewModel 초기화에 사용
          // 데이터를 받은 View를 리턴합니다.
          return CalendarEditScreen(initialCalendarData: calendarData);
        },
      ),

      // 공유 캘린더 - 알림
      GoRoute(
        path: '/notification',
        builder: (_, __) => const NotificationScreen(),
      ),

      // 캘린더 - 일정 - 상세
      GoRoute(
        path: "/schedule/detail",
        builder: (_, __) => const ScheduleDetailScreen(),
      ),

      // 바텀 네비게이션
      ShellRoute(
        builder: (_, _, child) => AppShell(child: child),
        routes: [
          // 공유 캘린더
          GoRoute(
            path: '/shared',
            builder: (_, __) => const SharedCalendarListScreen(),
            routes: [
              GoRoute(
                path: "add",
                builder: (_, __) => const ScheduleAddScreen(),
              ),
            ],
          ),

          // 내 캘린더
          GoRoute(
            path: '/personal',
            builder: (_, __) => const PersonalCalendarScreen(),
            routes: [
              GoRoute(
                path: "add",
                builder: (_, __) => const ScheduleAddScreen(),
              ),
            ],
          ),

          // 프로필
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
}
