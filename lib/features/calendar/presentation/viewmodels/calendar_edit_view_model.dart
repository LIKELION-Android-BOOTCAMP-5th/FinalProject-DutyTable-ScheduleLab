import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/widgets.dart';

class CalendarEditViewModel extends ChangeNotifier {
  /// 캘린더 제목 컨트롤러(private)
  late final TextEditingController _titleController = TextEditingController(
    text: _calendarResponse.title,
  );

  /// 캘린더 제목 컨트롤러(public)
  TextEditingController get titleController => _titleController;

  /// 캘린더 설명 컨트롤러(private)
  late final TextEditingController _descController = TextEditingController(
    text: _calendarResponse.description,
  );

  /// 캘린더 설명 컨트롤러(public)
  TextEditingController get descController => _descController;

  /// 캘린더 데이터(private)
  late CalendarModel _calendarResponse;

  /// 캘린더 데이터(public)
  CalendarModel get calendarResponse => _calendarResponse;

  /// 캘린더 수정 뷰모델
  CalendarEditViewModel({CalendarModel? initialCalendarData}) {
    if (initialCalendarData != null) {
      _calendarResponse = initialCalendarData;
    }
  }

  /// 컨트롤러 dispose
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
