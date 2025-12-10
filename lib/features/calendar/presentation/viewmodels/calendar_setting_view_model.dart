import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/widgets.dart';

class CalendarSettingViewModel extends ChangeNotifier {
  /// 캘린더 세팅 뷰모델
  CalendarSettingViewModel({CalendarModel? initialCalendarData}) {
    if (initialCalendarData != null) {
      _calendarResponse = initialCalendarData;
    }
  }

  /// 캘린더 데이터(private)
  late CalendarModel _calendarResponse;

  /// 캘린더 데이터(public)
  CalendarModel get calendarResponse => _calendarResponse;
}
