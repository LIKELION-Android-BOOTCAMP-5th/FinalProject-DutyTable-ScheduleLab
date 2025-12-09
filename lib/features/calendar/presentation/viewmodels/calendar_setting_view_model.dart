import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/widgets.dart';

class CalendarSettingViewModel extends ChangeNotifier {
  CalendarSettingViewModel({CalendarModel? initialCalendarData}) {
    // 전달받은 데이터로 _calendarResponse 초기화
    if (initialCalendarData != null) {
      _calendarResponse = initialCalendarData;
      print(_calendarResponse);

      // 초기화된 데이터를 바탕으로 다른 필드(예: 캘린더 이름, 설명 등) 업데이트
      // 예시: _calendarName = _calendarResponse.name;
    } else {
      // 데이터가 null일 경우, 기본값 설정 또는 에러 처리
      // 예: _calendarResponse = CalendarModel.empty();
    }
  }

  late CalendarModel _calendarResponse;
  CalendarModel get calendarResponse => _calendarResponse;
}
