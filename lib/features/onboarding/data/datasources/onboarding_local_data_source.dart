import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class OnboardingLocalDataSource {
  final SharedPreferences prefs;

  OnboardingLocalDataSource(this.prefs);

  Future<void> setOnboardingDone() async {
    await prefs.setBool("isOnboardingDone", true);
  }
}
