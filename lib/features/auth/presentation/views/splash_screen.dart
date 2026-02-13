import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/shared_calendar_view_model.dart';
import 'package:dutytable/features/notification/data/datasources/notification_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    if (!mounted) return;

    bool shouldRedirectToLogin = false;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;

      final isAutoLogin = prefs.getBool('auto_login') ?? true;

      if (!isAutoLogin) {
        await Supabase.instance.client.auth.signOut();
        if (!mounted) return;
      }

      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = isAutoLogin && session != null;

      if (isLoggedIn) {
        if (!mounted) return;
        await NotificationDataSource.shared.setupNotificationListenersAndState(
          context,
        );
        if (!mounted) return;
        context.read<SharedCalendarViewModel>().fetchCalendars();
      } else {
        shouldRedirectToLogin = true;
      }
    } catch (e) {
      debugPrint("Auth or Data prefetch failed: $e");
      shouldRedirectToLogin = true;
    }

    if (!mounted) return;

    if (shouldRedirectToLogin) {
      context.go('/login');
    } else {
      context.go('/shared');
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
