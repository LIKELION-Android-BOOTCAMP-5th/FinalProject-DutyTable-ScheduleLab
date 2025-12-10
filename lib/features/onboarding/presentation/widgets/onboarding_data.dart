class OnboardingData {
  final String title;
  final String body;
  final String image;

  OnboardingData({
    required this.title,
    required this.body,
    required this.image,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: '온보딩1',
    body: "동아리 일정을 한눈에 관리하고\n모든 활동을 체계적으로 정리하세요",
    image: 'assets/images/chat.png',
  ),
  OnboardingData(
    title: '온보딩2',
    body: "팀원과 실시간으로 소통하고\n중요한 공지를 놓치지 마세요",
    image: 'assets/images/calendar.png',
  ),
  OnboardingData(
    title: '온보딩3',
    body: "회비 내역을 투명하게 관리하고\n모든 거래를 한눈에 확인하세요",
    image: 'assets/images/money.png',
  ),
];
