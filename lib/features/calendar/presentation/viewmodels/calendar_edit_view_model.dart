import 'package:flutter/cupertino.dart';

class CalendarEditViewModel extends ChangeNotifier {
  TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  /// 캘린더 이름(local)
  final String _calendarName = "멋사 파이널 2조";

  /// 캘린더 이름(public)
  String get calendarName => _calendarName;

  /// 캘린더 설명(local)
  final String _calendarDescription =
      "시바안쩌고 마욱됵보다 렐개잉궉녀인, 하마아 으온릴논 검의 미바녀허나팀얘로 팟잔 삭인. 가쭘으로 싢뇨비스 카릭학엠이 르고움욱쩩온뜼의 횬헌알에, 한지 누쵸인내도 냠은이 레이김의 립룸, 영기오로써. 일잔마로 잭힐대흐게, 에서거홰파 그안이면서 잰소이는 모급휙킇더 인갈니브 능늑단가 처머쳐어아바 퇼골미텨의. 이단이 재으기 의팬이 시바집쿤이지만 며디그그 고다헬스 룬봉매농 나물까 열기졸루고 드구다. 됵르솬으니 마쿱수다 새닷이라 드셯린어 새엇으로 칼극카자다 어파건고 민드간좐국려다.린아느새 련오 지다가 덥셯의 이니덴딜 소무벨스 아쟁가런 갤훌즌여다 달토디숴어라. 만멌또싰고 쇼브이온, 이거토마떤일래 횹자뀨어 측아는 듼췰듼디 탱징델션잉지에 하라를 러으앝에 디이깃이에. 의믄우저혼 기우을다 비씬낱을 햐디즜이 가웃을 구반낙토으그 이기멈는다 아산흐조는, 도드누. 로마로 싰릐어 다진을 벱문싱저가 아라일부리의 할해건는 리소호드에, 치핸우당이며 오레뤌던데 삽쇼반은 퇀아누로 서즌헤느냐 끈듹 가서어에서 진미쉴조나 호예에.";

  /// 캘린더 설명(public)
  String get calendarDescription => _calendarDescription;

  final List<String> _calendarMember = ["권영진", "권양하", "서연우", "오민석", "이가은"];
  List<String> get calendarMember => _calendarMember;

  final List<bool> isAdmin = [true, false, false, false, false];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
