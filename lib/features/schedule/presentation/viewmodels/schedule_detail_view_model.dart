import 'package:flutter/material.dart';

class ScheduleDetailViewModeol extends ChangeNotifier {
  /// 일정 완료 상태
  bool _isDone = false;

  /// 일정 반복 상태
  bool _isRepeat = false;

  /// 일정 반복 옵션
  String _repeatType = "day"; // day, week, month, year
  int _repeatCount = 1;
  bool _excludeWeekend = false;
  bool _excludeHoliday = false;

  bool get isDone => _isDone;
  bool get isRepeat => _isRepeat;
  String get repeatType => _repeatType;
  int get repeatCount => _repeatCount;
  bool get excludeWeekend => _excludeWeekend;
  bool get excludeHoliday => _excludeHoliday;

  set isDone(bool value) {
    _isDone = value;
    notifyListeners();
  }

  set isRepeat(bool value) {
    _isRepeat = value;
    notifyListeners();
  }

  set repeatType(String value) {
    _repeatType = value;
    notifyListeners();
  }

  set repeatCount(int value) {
    _repeatCount = value;
    notifyListeners();
  }

  set excludeWeekend(bool value) {
    _excludeWeekend = value;
    notifyListeners();
  }

  set excludeHoliday(bool value) {
    _excludeHoliday = value;
    notifyListeners();
  }
}
