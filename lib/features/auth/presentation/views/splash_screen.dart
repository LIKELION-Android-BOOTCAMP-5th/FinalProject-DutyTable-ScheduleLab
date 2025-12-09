import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    // 마운트되지 않은 위젯에서 비동기 작업을 방지하기 위해 mounted 확인
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isAutoLogin = prefs.getBool('auto_login') ?? true;

      if (!isAutoLogin) {
        await Supabase.instance.client.auth.signOut();
      }

      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = isAutoLogin && session != null;

      if (!mounted) return;

      if (isLoggedIn) {
        context.go('/shared');
      } else {
        context.go('/login');
      }
    } catch (e) {
      // 오류 발생 시 로그인 화면으로 이동
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
