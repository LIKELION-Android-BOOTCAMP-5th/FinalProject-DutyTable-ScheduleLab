import 'dart:io';

import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/core/services/supabase_manager.dart';
import 'package:dutytable/features/auth/data/datasources/auth_data_source.dart';
import 'package:dutytable/features/auth/data/datasources/local_data_source.dart';
import 'package:dutytable/features/auth/data/datasources/user_data_source.dart';
import 'package:dutytable/features/auth/data/models/login_result_model.dart';
import 'package:dutytable/features/notification/data/datasources/notification_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/loading_dialog.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;
  final LocalDataSource _localDataSource;

  bool _isAutoLogin = true;
  bool get isAutoLogin => _isAutoLogin;

  bool _showOnboarding = false;
  bool get showOnboarding => _showOnboarding;

  LoginViewModel({
    AuthDataSource? authDataSource,
    UserDataSource? userDataSource,
    LocalDataSource? localDataSource,
  }) : _authDataSource = authDataSource ?? AuthDataSource(),
       _userDataSource = userDataSource ?? UserDataSource(),
       _localDataSource = localDataSource ?? LocalDataSource() {
    _init();
  }

  Future<void> _init() async {
    final done = await _localDataSource.isOnboardingDone();
    if (!done) {
      _showOnboarding = true;
      notifyListeners();
    }
  }

  void finishOnboarding() {
    _showOnboarding = false;
    notifyListeners();
  }

  void setAutoLogin(bool value) {
    _isAutoLogin = value;
    notifyListeners();
  }

  Future<void> googleSignIn(
    BuildContext context, {
    required bool isAutoLogin,
  }) async {
    showFullScreenLoading(context);
    try {
      await _authDataSource.signInWithGoogle();
      await _localDataSource.setAutoLogin(isAutoLogin);

      final result = await _userDataSource.postLoginProcess();

      if (!context.mounted) return;

      // 기존 사용자일 때만 기존 로직 유지(프리패치/알림 세팅)
      if (result.success && result.route == PostLoginRoute.shared) {
        try {
          await SupabaseManager.shared.getCalendars();
        } catch (_) {}

        await NotificationDataSource.shared.setupNotificationListenersAndState(
          context,
        );
      }

      _applyLoginResult(context, result);
    } catch (e) {
      _showError(context, '로그인 처리 중 오류 발생: $e');
    } finally {
      _closeLoadingSafely(context);
    }
  }

  Future<void> signInWithApple(
    BuildContext context, {
    required bool isAutoLogin,
  }) async {
    showFullScreenLoading(context);
    try {
      if (!Platform.isIOS) {
        throw Exception('Apple 로그인은 iOS에서만 지원합니다.');
      }

      await _authDataSource.signInWithApple();
      await _localDataSource.setAutoLogin(isAutoLogin);

      final result = await _userDataSource.postLoginProcess();

      if (!context.mounted) return;

      if (result.success && result.route == PostLoginRoute.shared) {
        try {
          await SupabaseManager.shared.getCalendars();
        } catch (_) {}

        await NotificationDataSource.shared.setupNotificationListenersAndState(
          context,
        );
      }

      _applyLoginResult(context, result);
    } catch (e) {
      _showError(context, '로그인 처리 중 오류 발생: $e');
    } finally {
      _closeLoadingSafely(context);
    }
  }

  void _applyLoginResult(BuildContext context, LoginResultModel result) {
    if (!result.success) {
      _showError(context, result.message ?? '알 수 없는 오류');
      return;
    }

    if (result.route == PostLoginRoute.shared) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "로그인이 성공하였습니다.",
            style: TextStyle(color: AppColors.textMain(context)),
          ),
          backgroundColor: AppColors.pureSuccess,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        ),
      );
      GoRouter.of(context).go('/shared');
      return;
    }

    if (result.route == PostLoginRoute.signup) {
      GoRouter.of(context).go('/signup');
      return;
    }
  }

  void _showError(BuildContext context, String msg) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: AppColors.textMain(context)),
        ),
        backgroundColor: AppColors.danger(context),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      ),
    );
  }

  void _closeLoadingSafely(BuildContext context) {
    if (!context.mounted) return;

    if (context.canPop()) context.pop();
  }
}
