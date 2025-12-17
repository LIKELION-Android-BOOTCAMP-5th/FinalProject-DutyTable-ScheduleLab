import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/widgets.dart';

class CalendarSettingViewModel extends ChangeNotifier {
  /// 캘린더 데이터(private)
  late CalendarModel _calendar;

  /// 캘린더 데이터(public)
  CalendarModel get calendar => _calendar;

  final currentUser = supabase.auth.currentUser;

  /// 캘린더 세팅 뷰모델
  CalendarSettingViewModel({CalendarModel? calendar}) {
    if (calendar != null) {
      _calendar = calendar;
    }
  }

  /// 단일 캘린더 불러오기
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

  /// 캘린더 나가기(멤버만)
  Future<void> outCalendar() async {
    CalendarDataSource.instance.outCalendar(_calendar.id);
  }

  /// 캘린더 삭제(방장만)
  Future<void> deleteCalendar() async {
    CalendarDataSource.instance.deleteCalendar(_calendar.id);
  }
}
