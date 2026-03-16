import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/calendar/domain/entities/detected_schedule.dart';
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

  /// 반복 종료 옵션 ('count': 횟수 기준, 'date': 날짜 기준)
  String _endOption = "count";

  /// 반복 종료 날짜 (날짜 기준 선택 시 사용)
  DateTime _endDateForRepeat = DateTime.now().add(const Duration(days: 30));

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

  String get endOption => _endOption;
  DateTime get endDateForRepeat => _endDateForRepeat;

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

  void updateEndOption(String value) {
    _endOption = value;
    _calculateRepeatCountFromDate(); // 옵션 변경 시 횟수 재계산
    notifyListeners();
  }

  void updateEndDateForRepeat(DateTime value) {
    _endDateForRepeat = value;
    _calculateRepeatCountFromDate(); // 날짜 변경 시 횟수 재계산
    notifyListeners();
  }

  /// 종료 날짜를 기준으로 repeatCount를 역산하는 로직
  void _calculateRepeatCountFromDate() {
    if (_endOption != 'date') return;

    int count = 0;
    DateTime tempDate = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
    );
    DateTime targetEndDate = DateTime(
      _endDateForRepeat.year,
      _endDateForRepeat.month,
      _endDateForRepeat.day,
    );

    // 안전을 위해 최대 1000회까지만 계산
    while ((tempDate.isBefore(targetEndDate) ||
            tempDate.isAtSameMomentAs(targetEndDate)) &&
        count < 1000) {
      count++;
      tempDate = tempDate.jumpToNextWorkingDay(
        repeatOption: _repeatOption,
        repeatNum: _repeatNum,
        holidays: [],
        weekendException: _weekendException,
        holidayException: _holidayException,
      );
    }
    _repeatCount = count > 0 ? count : 1;
  }

  //-------------------- Create --------------------

  /// 일정 - 추가 (Edge Function 호출 방식으로 변경)
  Future<void> addSchedule(int calendarId) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final Map<String, dynamic> payload = {
        'calendarId': calendarId,
        'title': _title.trim(),
        'emotionTag': _emotionTag,
        'colorValue': _colorValue,
        'isDone': _isDone,

        // 날짜 및 시간 정보 (문자열로 전달)
        'startDate': _startDate.toIso8601String().split('T')[0], // yyyy-MM-dd
        'startTime':
            '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
        'endTime':
            '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',

        // 반복 관련 설정
        'isRepeat': _isRepeat,
        'repeatOption': _isRepeat ? _repeatOption : 'none',
        'repeatNum': _isRepeat ? _repeatNum : 1,
        'repeatCount': _isRepeat ? _repeatCount : 1,
        'weekendException': _weekendException,
        'holidayException': _holidayException,

        // 사용자가 직접 선택한 제외 날짜들
        'excludedDates': _excludedDates
            .map((d) => d.toIso8601String().split('T')[0])
            .toList(),

        // 기타 정보
        'address': _address,
        'latitude': _latitude,
        'longitude': _longitude,
        'memo': _memo.trim().isEmpty ? null : _memo.trim(),
      };

      await _addScheduleUseCase(payload);

      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      debugPrint('❌ addSchedule (Edge Function) error: $e');
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

  /// AI 감지 일정으로 초기값 세팅
  void prefillFromDetectedSchedule(DetectedSchedule schedule) {
    if (schedule.title.isNotEmpty) {
      _title = schedule.title;
    }
    final parts = schedule.time.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]) ?? 7;
      final m = int.tryParse(parts[1]) ?? 0;
      _startTime = TimeOfDay(hour: h, minute: m);
      _endTime = TimeOfDay(hour: (h + 1).clamp(0, 23), minute: m);
    }
    if (schedule.place != null && schedule.place!.isNotEmpty) {
      _address = schedule.place;
      addressController.text = schedule.place!;
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }
}
