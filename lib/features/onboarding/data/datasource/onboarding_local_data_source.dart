import 'package:dutytable/features/onboarding/data/models/onboarding_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class OnboardingLocalDataSource {
  List<OnboardingModel> onboardingPages() {
    return [
      OnboardingModel(
        title: '일정 소통',
        body: "선택한 캘린더 멤버들과\n일정 관련 대화를 나눠보세요",
        image: 'assets/images/chatting.png',
      ),
      OnboardingModel(
        title: '일정 공유',
        body: "가족, 친구, 팀원과 일정을 공유하고\n한눈에 확인하세요",
        image: 'assets/images/sharing.png',
      ),
      OnboardingModel(
        title: '일정 알림',
        body: "중요한 일정\n알림으로 놓치지 마세요",
        image: 'assets/images/alarm.png',
      ),
    ];
  }

  Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isOnboardingDone", true);
  }
}
