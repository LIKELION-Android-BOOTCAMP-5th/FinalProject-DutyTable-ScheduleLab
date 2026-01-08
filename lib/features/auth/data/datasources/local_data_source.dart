import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isOnboardingDone') ?? false;
  }

  Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingDone', true);
  }

  Future<void> setAutoLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_login', value);
  }

  Future<bool> isAutoLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('auto_login') ?? true;
  }
}
