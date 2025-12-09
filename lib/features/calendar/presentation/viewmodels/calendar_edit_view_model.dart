import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/widgets.dart';

class CalendarEditViewModel extends ChangeNotifier {
  CalendarEditViewModel({CalendarModel? initialCalendarData}) {
    if (initialCalendarData != null) {
      _calendarResponse = initialCalendarData;
      print(_calendarResponse);
    } else {
      // 데이터가 null일 경우, 기본값 설정 또는 에러 처리
      // 예: _calendarResponse = CalendarModel.empty();
    }
  }

  late final TextEditingController _titleController = TextEditingController(
    text: _calendarResponse.title,
  );
  TextEditingController get titleController => _titleController;

  late final TextEditingController _descController = TextEditingController(
    text: _calendarResponse.description,
  );
  TextEditingController get descController => _descController;

  late CalendarModel _calendarResponse;
  CalendarModel get calendarResponse => _calendarResponse;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
