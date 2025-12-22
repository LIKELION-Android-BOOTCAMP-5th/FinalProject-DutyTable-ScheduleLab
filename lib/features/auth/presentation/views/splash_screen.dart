import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/notification/data/datasources/notification_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../calendar/data/datasources/calendar_data_source.dart';
import '../../../calendar/data/models/calendar_model.dart';

// 앱 시작 시 사용자 인증 상태를 확인하고 적절한 화면으로 이동하는 스플래시 화면
// 로그인 여부 밒 자동 로그인 설정에 따라 사용자를 로그인 페이지 또는 메인 페이지로 안내
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirect();
    });
  }

  Future<void> _redirect() async {
    // 마운트되지 않은 위젯에서 비동기 작업을 방지하기 위해 mounted 확인
    if (!mounted) return;

    // 로드할 캘린더 데이터 변수
    List<CalendarModel>? sharedCalendars;

    // 로그인 화면으로 이동해야 하는지 여부 플래그
    bool shouldRedirectToLogin = false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isAutoLogin = prefs.getBool('auto_login') ?? true;

      // 자동 로그인이 꺼져 있다면 로그아웃
      if (!isAutoLogin) {
        await Supabase.instance.client.auth.signOut();
      }

      // 현재 세션 확인
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = isAutoLogin && session != null;

      if (isLoggedIn) {
        // 로그인 상태인 경우, 데이터 로드 및 알림 리스너 설정
        await NotificationDataSource.shared.setupNotificationListenersAndState(
          context,
        );
        sharedCalendars = await CalendarDataSource.instance
            .fetchCalendarFinalList("group");
      } else {
        // 로그인 상태가 아닌 경우, 로그인 화면으로 이동 플래그 설정
        shouldRedirectToLogin = true;
      }
    } catch (e) {
      // 인증 또는 데이터 로드 중 오류 발생 시
      debugPrint("Auth or Data prefetch failed: $e");
      shouldRedirectToLogin = true; // 오류 발생 시 로그인 화면으로 이동
    } finally {
      if (!mounted) return;

      if (shouldRedirectToLogin) {
        // 자동 로그인 설정이 꺼졌거나, 인증/데이터 로드에 실패하면 로그인으로 이동
        context.go('/login');
      } else {
        // 인증 및 데이터 로드에 성공하면 메인 화면으로 이동하며 데이터를 전달
        context.go('/shared', extra: {'sharedCalendars': sharedCalendars});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 데이터 로딩 중에는 로딩 인디케이터만 표시
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary(context),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
