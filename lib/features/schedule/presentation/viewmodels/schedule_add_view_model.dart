import 'package:flutter/material.dart';

class ScheduleAddViewModel extends ChangeNotifier {
  /// 감정 이모지 리스트
  static const List<String> emotionList = ["😢", "😕", "🙂", "😐", "😊"];

  /// 색 리스트
  static const List<int> colorList = [
    0xFFFF3B30,
    0xFFFF9500,
    0xFFFFCC00,
    0xFF34C759,
    0xFF32ADE6,
    0xFF007AFF,
    0xFFAF52DE,
  ];

  /// 감정 선택
  String? _selectedEmotion = "😢";

  /// 컬러 선택
  int? _selectedColor = 0xFFFF3B30;

  /// 제목

  /// 일정 완료 상태
  bool _isDone = false;

  /// 일정 반복 상태
  bool _isRepeat = false;

  /// 일정 반복 옵션
  String _repeatType = "day"; // day, week, month, year
  int _repeatCount = 1;
  bool _excludeWeekend = false;
  bool _excludeHoliday = false;

  /// 일정 날짜
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  /// 일정 시간
  TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 8, minute: 0);

  /// 주소
  String? _address;

  /// 메모
  String _memo = "";

  /// getter
  String? get selectedEmotion => _selectedEmotion;
  int? get selectedColor => _selectedColor;
  bool get isDone => _isDone;
  bool get isRepeat => _isRepeat;
  String get repeatType => _repeatType;
  int get repeatCount => _repeatCount;
  bool get excludeWeekend => _excludeWeekend;
  bool get excludeHoliday => _excludeHoliday;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  String? get address => _address;
  String get memo => _memo;

  /// setter
  set selectedEmotion(String? value) {
    _selectedEmotion = value;
    notifyListeners();
  }

  set selectedColor(int? value) {
    _selectedColor = value;
    notifyListeners();
  }

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

  set startDate(DateTime value) {
    _startDate = value;
    notifyListeners();
  }

  set endDate(DateTime value) {
    _endDate = value;
    notifyListeners();
  }

  set startTime(TimeOfDay value) {
    _startTime = value;
    notifyListeners();
  }

  set endTime(TimeOfDay value) {
    _endTime = value;
    notifyListeners();
  }

  set address(String? value) {
    _address = value;
    notifyListeners();
  }

  set memo(String value) {
    if (value.length <= 300) {
      _memo = value;
      notifyListeners();
    }
  }

  void clearAddress() {
    _address = null;
    notifyListeners();
  }
}
