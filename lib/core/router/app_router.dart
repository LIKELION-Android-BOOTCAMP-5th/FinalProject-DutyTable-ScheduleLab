import 'package:dutytable/features/calendar/presentation/views/add_calendar_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/calendar_edit_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/personal/personal_calendar_screen.dart';
import 'package:dutytable/features/calendar/presentation/views/shared/shared_calendar_screen.dart';
import 'package:dutytable/features/notification/presentation/views/notification_screen.dart';
import 'package:dutytable/features/profile/presentation/views/profile_screen.dart';
import 'package:dutytable/features/schedule/presentation/views/schedule_add_screen.dart';
import 'package:dutytable/features/schedule/presentation/views/schedule_detail_screen.dart';
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
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),

      // 로그인
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

      // 회원가입
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),

      // 공유 캘린더 - 캘린더 추가
      GoRoute(
        path: '/calendar/add',
        builder: (_, __) => const AddCalendarScreen(),
      ),

      GoRoute(
        path: '/calendar/setting',
        builder: (context, state) {
          final CalendarModel? calendarData = state.extra as CalendarModel?;
          return CalendarSettingScreen(initialCalendarData: calendarData);
        },
      ),

      GoRoute(
        path: '/calendar/edit',
        builder: (context, state) {
          final CalendarModel? calendarData = state.extra as CalendarModel?;
          return CalendarEditScreen(initialCalendarData: calendarData);
        },
      ),

      // 알림
      GoRoute(
        path: '/notification',
        builder: (_, __) => const NotificationScreen(),
      ),

      // 캘린더 - 일정 - 추가
      GoRoute(
        path: "/schedule/add",
        builder: (_, __) => const ScheduleAddScreen(),
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
          GoRoute(
            path: '/shared',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final List<CalendarModel>? initialCalendars =
                  extra?['sharedCalendars'] as List<CalendarModel>?;

              return SharedCalendarListScreen(
                initialCalendars: initialCalendars,
              );
            },
            routes: [
              GoRoute(
                path: "schedule",
                builder: (context, state) {
                  // 2단계 : 데이터랑 같이 라우팅
                  final CalendarModel calendarResponse =
                      state.extra as CalendarModel;

                  return SharedCalendarScreen(
                    calendarResponse: calendarResponse,
                  );
                },
              ),
            ],
          ),

          // 내 캘린더
          GoRoute(
            path: '/personal',
            builder: (_, __) {
              return PersonalCalendarScreen();
            },
          ),

          // 프로필
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
}
