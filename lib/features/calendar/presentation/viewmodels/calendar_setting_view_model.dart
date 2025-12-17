import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/widgets.dart';

class CalendarSettingViewModel extends ChangeNotifier {
  /// 캘린더 데이터(private)
  late CalendarModel _calendar;

  /// 캘린더 데이터(public)
  CalendarModel get calendar => _calendar;

  /// 캘린더 세팅 뷰모델
  CalendarSettingViewModel({CalendarModel? calendar}) {
    if (calendar != null) {
      _calendar = calendar;
    }
  }

  Future<void> fetchCalendar() async {
    if (_calendar.type == 'personal') {
      _calendar = await CalendarDataSource.instance.fetchPersonalCalendar();
    } else {
      _calendar = await CalendarDataSource.instance.fetchSharedCalendarFromId(
        _calendar.id,
      );
    }
    notifyListeners();
  }
}
