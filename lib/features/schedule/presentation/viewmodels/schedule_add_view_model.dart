import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/schedule/domain/usecases/add_schedule_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/fetch_holidays_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/geocode_address_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum ViewState { idle, loading, success, error }

@injectable
class ScheduleAddViewModel extends ChangeNotifier {
  //-------------------- UseCase --------------------

  final AddScheduleUseCase _addScheduleUseCase;
  final FetchHolidaysUseCase _fetchHolidaysUseCase;
  final GeocodeAddressUseCase _geocodeAddressUseCase;

  //-------------------- UI --------------------

  final TextEditingController addressController = TextEditingController();

  ViewState _state = ViewState.idle;

  //-------------------- Fields --------------------

  /// 감정 선택
  String _emotionTag = "😐";

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

  /// 제외할 특정 날짜 리스트
  List<DateTime> _excludedDates = [];

  //-------------------- Getters --------------------
  ViewState get state => _state;

  String get emotionTag => _emotionTag;
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

  List<DateTime> get excludedDates => _excludedDates;

  //-------------------- Constructor --------------------

  ScheduleAddViewModel(
    this._addScheduleUseCase,
    this._fetchHolidaysUseCase,
    this._geocodeAddressUseCase,
    @factoryParam DateTime? date,
  ) {
    if (date != null) {
      _startDate = date;
      _endDate = date;
    } else {
      _startDate = DateTime.now();
      _endDate = DateTime.now();
    }
  }

  //-------------------- Setters --------------------

  set selectedEmotion(String value) {
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

  /// 제외 날짜 추가 (중복 체크 포함)
  void addExcludedDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (!_excludedDates.contains(dateOnly)) {
      _excludedDates.add(dateOnly);
      _excludedDates.sort(); // 날짜순 정렬
      notifyListeners();
    }
  }

  /// 제외 날짜 삭제
  void removeExcludedDate(int index) {
    _excludedDates.removeAt(index);
    notifyListeners();
  }

  //-------------------- Create --------------------

  /// 일정 - 추가
  Future<void> addSchedule(int calendarId) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      List<DateTime> holidays = [];
      if (_isRepeat && _holidayException) {
        holidays = await _fetchHolidaysUseCase(_startDate.year);
      }

      final String? groupId = _isRepeat
          ? "group_${DateTime.now().millisecondsSinceEpoch}_$calendarId"
          : null;

      List<Map<String, dynamic>> payloads = [];
      int createdCount = 0;
      int targetCount = _isRepeat ? (_repeatCount) : 1;

      final scheduleDuration = DateTime(
        2000,
        1,
        1,
        _endTime.hour,
        _endTime.minute,
      ).difference(DateTime(2000, 1, 1, _startTime.hour, _startTime.minute));

      DateTime currentStartDate = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
      );
      int attempts = 0;

      while (createdCount < targetCount && attempts < 3000) {
        attempts++;

        // 기존 예외(주말, 공휴일) + 사용자가 직접 추가한 제외 날짜(_excludedDates) 체크
        bool isExcludedByUser = _excludedDates.any(
          (d) =>
              d.year == currentStartDate.year &&
              d.month == currentStartDate.month &&
              d.day == currentStartDate.day,
        );

        if (isExcludedByUser ||
            currentStartDate.checkIsException(
              holidays: holidays,
              weekendException: _weekendException,
              holidayException: _holidayException,
            )) {
          currentStartDate = currentStartDate.add(const Duration(days: 1));
          continue;
        }

        DateTime startDateTime = DateTime(
          currentStartDate.year,
          currentStartDate.month,
          currentStartDate.day,
          _startTime.hour,
          _startTime.minute,
        );

        payloads.add({
          'calendar_id': calendarId,
          'repeat_group_id': groupId,
          'title': _title.trim(),
          'emotion_tag': _emotionTag,
          'color_value': _colorValue,
          'is_done': _isDone,
          'started_at': startDateTime.toUtc().toIso8601String(),
          'ended_at': startDateTime
              .add(scheduleDuration)
              .toUtc()
              .toIso8601String(),
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
        if (!_isRepeat) break;

        currentStartDate = currentStartDate.jumpToNextWorkingDay(
          repeatOption: _repeatOption,
          repeatNum: _repeatNum,
          holidays: holidays,
          weekendException: _weekendException,
          holidayException: _holidayException,
        );
      }

      if (payloads.isNotEmpty) {
        await _addScheduleUseCase(payloads);
      }
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      debugPrint('❌ addSchedule error: $e');
    } finally {
      notifyListeners();
    }
  }

  void setMemo(String value) {
    if (value.length <= 300) {
      _memo = value;
      notifyListeners();
    }
  }

  //-------------------- Update --------------------

  /// 위치 수정 ->
  Future<void> updateLocationAction(String newAddress) async {
    try {
      final geo = await _geocodeAddressUseCase(newAddress);

      setLocation(
        address: newAddress,
        latitude: geo.latitude,
        longitude: geo.longitude,
      );
    } catch (e) {
      debugPrint("❌ updateLocationAction error: $e");
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

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
