import 'dart:developer';

import 'package:dutytable/features/schedule/data/datasources/schedule_data_source.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';

enum ViewState { idle, loading, success, error }

class ScheduleAddViewModel extends ChangeNotifier {
  final TextEditingController addressController = TextEditingController();

  /// 데이터 로딩 상태(private)
  ViewState _state = ViewState.idle;

  /// 데이터 로딩 상태(public)
  ViewState get state => _state;

  /// 감정 선택
  String? _emotionTag;

  /// 컬러 선택
  String _colorValue = "0xFFFF3B30";

  /// 제목
  String _title = "";

  /// 일정 완료 상태
  bool _isDone = false;

  /// 일정 날짜
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  /// 일정 시간
  TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 8, minute: 0);

  /// 일정 반복 상태
  bool _isRepeat = false;
  String _repeatOption = "daily";
  int _repeatNum = 1;
  bool _weekendException = false;
  bool _holidayException = false;
  int _repeatCount = 1;

  /// 주소
  String? _address;
  String? _longitude;
  String? _latitude;

  /// 메모
  String _memo = "";

  /// getter
  String? get emotionTag => _emotionTag;
  String get colorValue => _colorValue;
  String get title => _title;

  bool get isDone => _isDone;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;

  bool get isRepeat => _isRepeat;
  String get repeatOption => _repeatOption;
  int get repeatNum => _repeatNum;
  bool get weekendException => _weekendException;
  bool get holidayException => _holidayException;
  int get repeatCount => _repeatCount;

  String? get address => _address;
  String? get longitude => _longitude;
  String? get latitude => _latitude;

  String get memo => _memo;

  /// setter
  set selectedEmotion(String? value) {
    _emotionTag = value;
    notifyListeners();
  }

  set selectedColor(String value) {
    _colorValue = value;
    notifyListeners();
  }

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setIsDone(bool value) {
    _isDone = value;
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

  set isRepeat(bool value) {
    _isRepeat = value;
    notifyListeners();
  }

  set repeatOption(String value) {
    _repeatOption = value;
    notifyListeners();
  }

  set repeatNum(int value) {
    _repeatNum = value;
    notifyListeners();
  }

  set weekendException(bool value) {
    _weekendException = value;
    notifyListeners();
  }

  set holidayException(bool value) {
    _holidayException = value;
    notifyListeners();
  }

  set repeatCount(int value) {
    _repeatCount = value;
    notifyListeners();
  }

  ScheduleAddViewModel(DateTime? date) {
    if (date != null) {
      _startDate = date;
      _endDate = date;
    } else {
      _startDate = DateTime.now();
      _endDate = DateTime.now();
    }
  }

  void setLocation({
    required String address,
    required String latitude,
    required String longitude,
  }) {
    _address = address;
    _latitude = latitude;
    _longitude = longitude;

    // 컨트롤러 텍스트 동기화
    addressController.text = address;
    notifyListeners();
  }

  void clearAddress() {
    _address = null;
    _latitude = null;
    _longitude = null;

    addressController.clear();
    notifyListeners();
  }

  void setMemo(String value) {
    if (value.length <= 300) {
      _memo = value;
      notifyListeners();
    }
  }

  Future<void> updateLocationAction(String newAddress) async {
    try {
      final geo = await geocodeAddress(newAddress);
      if (geo == null) return;

      setLocation(
        address: newAddress,
        latitude: geo['latitude']!.toString(),
        longitude: geo['longitude']!.toString(),
      );
    } catch (e) {
      debugPrint("❌ updateLocationAction error: $e");
    }
  }

  /// 일정 - 추가
  Future<void> addSchedule(int calendarId) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      List<DateTime> holidays = [];
      if (_isRepeat && _holidayException) {
        holidays = await ScheduleDataSource.instance.fetchHolidays();
      }

      final String? groupId = _isRepeat
          ? "group_${DateTime.now().millisecondsSinceEpoch}_$calendarId"
          : null;

      List<Map<String, dynamic>> payloads = [];
      int createdCount = 0;

      final scheduleDuration =
          DateTime(
            _endDate.year,
            _endDate.month,
            _endDate.day,
            _endTime.hour,
            _endTime.minute,
          ).difference(
            DateTime(
              _startDate.year,
              _startDate.month,
              _startDate.day,
              _startTime.hour,
              _startTime.minute,
            ),
          );

      DateTime currentStartDate = _startDate;
      int targetCount = _isRepeat ? _repeatCount : 1;

      int attempts = 0;

      while (createdCount < targetCount && attempts < 1000) {
        attempts++;

        bool isWeekend =
            currentStartDate.weekday == DateTime.saturday ||
            currentStartDate.weekday == DateTime.sunday;

        bool isHoliday = holidays.any(
          (h) =>
              h.year == currentStartDate.year &&
              h.month == currentStartDate.month &&
              h.day == currentStartDate.day,
        );

        bool shouldSkip =
            _isRepeat &&
            ((_weekendException && isWeekend) ||
                (_holidayException && isHoliday));

        if (!shouldSkip) {
          DateTime startDateTime = DateTime(
            currentStartDate.year,
            currentStartDate.month,
            currentStartDate.day,
            _startTime.hour,
            _startTime.minute,
          );

          DateTime endDateTime = startDateTime.add(scheduleDuration);

          payloads.add({
            'calendar_id': calendarId,
            'repeat_group_id': groupId,
            'title': _title.trim(),
            'emotion_tag': _emotionTag,
            'color_value': _colorValue,
            'is_done': _isDone,
            'started_at': startDateTime.toUtc().toIso8601String(),
            'ended_at': endDateTime.toUtc().toIso8601String(),
            'is_repeat': _isRepeat,
            'repeat_option': _isRepeat ? _repeatOption : null,
            'repeat_num': _isRepeat ? _repeatNum : null,
            'weekend_exception': _isRepeat ? _weekendException : false,
            'holiday_exception': _isRepeat ? _holidayException : false,
            'repeat_count': _isRepeat ? _repeatCount : null,
            'address': _address,
            'latitude': _latitude,
            'longitude': _longitude,
            'memo': _memo.trim().isEmpty ? null : _memo.trim(),
          });
          createdCount++;
        }

        if (!_isRepeat) break;

        if (_repeatOption == "daily") {
          currentStartDate = currentStartDate.add(Duration(days: _repeatNum));
        } else if (_repeatOption == "weekly") {
          currentStartDate = currentStartDate.add(
            Duration(days: _repeatNum * 7),
          );
        } else if (_repeatOption == "monthly") {
          currentStartDate = DateTime(
            currentStartDate.year,
            currentStartDate.month + _repeatNum,
            currentStartDate.day,
          );
        } else if (_repeatOption == "yearly") {
          currentStartDate = DateTime(
            currentStartDate.year + _repeatNum,
            currentStartDate.month,
            currentStartDate.day,
          );
        }
      }

      log(payloads.toString(), name: 'SCHEDULE_PAYLOAD');

      if (payloads.isNotEmpty) {
        await ScheduleDataSource.instance.addSchedule(payloads);
      }

      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      debugPrint('❌ addSchedule error: $e');
    } finally {
      notifyListeners();
    }
  }

  /// 주소 입력 -> 네이버 gecode -> 위도 경도로 변환
  Future<Map<String, double>?> geocodeAddress(String address) async {
    final response = await supabase.functions.invoke(
      'hyper-endpoint',
      body: {'type': 'geocode', 'address': address},
    );

    if (response.data == null) return null;

    return {
      'latitude': (response.data['latitude'] as num).toDouble(),
      'longitude': (response.data['longitude'] as num).toDouble(),
    };
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
