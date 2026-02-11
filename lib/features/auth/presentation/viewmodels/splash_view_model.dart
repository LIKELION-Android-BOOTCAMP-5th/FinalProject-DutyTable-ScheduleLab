import 'package:dutytable/features/calendar/domain/entities/calendar_entity.dart';
import 'package:dutytable/features/calendar/domain/usecases/read_calendar_final_list_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/usecases/redirect_use_case.dart';

/// 스플래시 화면의 비즈니스 로직을 관리하는 ViewModel.
@injectable
class SplashViewModel with ChangeNotifier {
  final ReadCalendarFinalListUseCase _readCalendarFinalListUseCase;
  final RedirectUseCase _redirectUseCase;
  // redirect 메서드가 중복 실행되는 것을 방지하기 위한 플래그
  bool _isRedirecting = false;

  SplashViewModel(this._readCalendarFinalListUseCase, this._redirectUseCase) {}

  /// 앱 초기화 및 경로 재지정을 담당하는 비동기 메서드.
  /// 위젯 트리에서 단 한 번만 호출 --- 유즈케이스,LocalRepository
  Future<void> redirect(BuildContext context) async {
    // 중복 실행 방지
    if (_isRedirecting) return;
    _isRedirecting = true;

    // 로드할 캘린더 데이터 변수
    List<CalendarEntity>? sharedCalendars;
    // 로그인 화면으로 이동해야 하는지 여부 플래그
    bool shouldRedirectToLogin = false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isAutoLogin = prefs.getBool('auto_login') ?? true;

      if (!isAutoLogin) {
        await Supabase.instance.client.auth.signOut();
      }

      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = isAutoLogin && session != null;

      if (isLoggedIn) {
        sharedCalendars = await _readCalendarFinalListUseCase("group");

        if (!context.mounted) return;

        _redirectUseCase(context);
      } else {
        shouldRedirectToLogin = true;
      }
    } catch (e) {
      debugPrint("Auth or Data prefetch failed: $e");
      shouldRedirectToLogin = true;
    } finally {
      // 위젯이 아직 화면에 있는지 확인 후 내비게이션 실행
      if (context.mounted) {
        if (shouldRedirectToLogin) {
          context.go('/login');
        } else {
          context.go('/shared', extra: {'sharedCalendars': sharedCalendars});
        }
      }
    }
  }

  bool _isDisposed = false;
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}
