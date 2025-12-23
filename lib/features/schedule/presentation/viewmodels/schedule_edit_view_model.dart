import 'dart:developer';
import 'package:dutytable/features/schedule/data/datasources/schedule_data_source.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';

enum EditViewState { idle, loading, success, error }

class ScheduleEditViewModel extends ChangeNotifier {
  final ScheduleModel _scheduleFromEdit;
  final TextEditingController addressController = TextEditingController();

  EditViewState _state = EditViewState.idle;
  EditViewState get state => _state;

  late String _title;
  late String? _emotionTag;
  late String _colorValue;
  late bool _isDone;
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _isRepeat;
  late String _repeatOption;
  late int _repeatNum;
  late bool _weekendException;
  late bool _holidayException;
  late int _repeatCount;
  String? _address;
  String? _latitude;
  String? _longitude;
  String _memo = "";

  /// ===== getter =====
  int get scheduleId => _scheduleFromEdit.id;
  String? get repeatGroupId => _scheduleFromEdit.repeatGroupId;
  String get title => _title;
  String? get emotionTag => _emotionTag;
  String get colorValue => _colorValue;
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
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String get memo => _memo;

  ScheduleEditViewModel({required ScheduleModel schedule})
    : _scheduleFromEdit = schedule {
    _title = schedule.title;
    _emotionTag = schedule.emotionTag;
    _colorValue = schedule.colorValue;
    _isDone = schedule.isDone;

    _startDate = DateTime(
      schedule.startedAt.year,
      schedule.startedAt.month,
      schedule.startedAt.day,
    );
    _endDate = DateTime(
      schedule.endedAt.year,
      schedule.endedAt.month,
      schedule.endedAt.day,
    );
    _startTime = TimeOfDay(
      hour: schedule.startedAt.hour,
      minute: schedule.startedAt.minute,
    );
    _endTime = TimeOfDay(
      hour: schedule.endedAt.hour,
      minute: schedule.endedAt.minute,
    );

    _isRepeat = schedule.isRepeat;
    _repeatOption = schedule.repeatOption ?? 'daily';
    _repeatNum = schedule.repeatNum ?? 1;
    _weekendException = schedule.weekendException ?? false;
    _holidayException = schedule.holidayException ?? false;
    _repeatCount = schedule.repeatCount ?? 1;

    _address = schedule.address;
    _latitude = schedule.latitude;
    _longitude = schedule.longitude;
    _memo = schedule.memo ?? "";
    addressController.text = _address ?? "";
  }

  void _set(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  void setEmotion(String? v) => _set(() => _emotionTag = v);
  void setColor(String v) => _set(() => _colorValue = v);
  void setTitle(String v) => _set(() => _title = v);
  void setMemo(String v) => _set(() => _memo = v);
  void setIsDone(bool v) => _set(() => _isDone = v);
  void setStartDate(DateTime v) => _set(() => _startDate = v);
  void setEndDate(DateTime v) => _set(() => _endDate = v);
  void setStartTime(TimeOfDay v) => _set(() => _startTime = v);
  void setEndTime(TimeOfDay v) => _set(() => _endTime = v);
  void setIsRepeat(bool v) => _set(() => _isRepeat = v);
  void setRepeatNum(int v) => _set(() => _repeatNum = v);
  void setRepeatOption(String v) => _set(() => _repeatOption = v);
  void setWeekendException(bool v) => _set(() => _weekendException = v);
  void setHolidayException(bool v) => _set(() => _holidayException = v);
  void setRepeatCount(int v) => _set(() => _repeatCount = v);

  Future<void> updateSingleSchedule() async =>
      await _performUpdate(isAll: false);

  Future<void> updateAllSchedulesInGroup() async {
    if (repeatGroupId == null) {
      await updateSingleSchedule();
    } else {
      await _performUpdate(isAll: true);
    }
  }

  Future<void> _performUpdate({required bool isAll}) async {
    _state = EditViewState.loading;
    notifyListeners();

    try {
      final startedAt = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      final endedAt = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      final Map<String, dynamic> commonPayload = {
        'title': _title.trim(),
        'emotion_tag': _emotionTag,
        'color_value': _colorValue,
        'address': _address,
        'latitude': _latitude,
        'longitude': _longitude,
        'memo': _memo.trim().isEmpty ? null : _memo.trim(),
        'is_done': _isDone,
        'weekend_exception': _weekendException,
        'holiday_exception': _holidayException,
      };

      if (isAll && repeatGroupId != null) {
        // ✅ 1. 기존 반복 그룹 일정 전체 삭제
        await ScheduleDataSource.instance.deleteSchedulesByGroupId(
          repeatGroupId!,
        );

        // ✅ 2. 새로운 조건으로 일정 리스트 재생성
        // (ID는 삭제되었으므로 기존 repeatGroupId를 재사용하거나 새로 생성하여 전달)
        final newSchedules = await _generateNewSchedules(repeatGroupId!);

        // ✅ 3. 재생성된 일정들을 INSERT
        await ScheduleDataSource.instance.addSchedule(newSchedules);
      } else {
        // 단건 수정 로직
        final singlePayload = {
          ...commonPayload,
          'started_at': startedAt.toUtc().toIso8601String(),
          'ended_at': endedAt.toUtc().toIso8601String(),
          'is_repeat': _isRepeat,
          'repeat_option': _isRepeat ? _repeatOption : null,
          'repeat_num': _isRepeat ? _repeatNum : null,
          'repeat_count': _isRepeat ? _repeatCount : null,
        };
        await ScheduleDataSource.instance.updateSchedule(
          scheduleId: scheduleId,
          payload: singlePayload,
        );
      }

      _state = EditViewState.success;
    } catch (e) {
      _state = EditViewState.error;
      debugPrint('❌ update error: $e');
    } finally {
      notifyListeners();
    }
  }

  /// ✅ 새로운 반복 일정 리스트를 생성하는 로직
  Future<List<Map<String, dynamic>>> _generateNewSchedules(
    String groupId,
  ) async {
    List<Map<String, dynamic>> payloads = [];

    // 공휴일 정보 가져오기 (예외 처리를 위해)
    List<DateTime> holidays = [];
    if (_holidayException) {
      holidays = await ScheduleDataSource.instance.fetchHolidays();
    }

    DateTime currentStart = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    DateTime currentEnd = DateTime(
      _endDate.year,
      _endDate.month,
      _endDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    int createdCount = 0;
    int safetyLoop = 0; // 무한 루프 방지

    while (createdCount < _repeatCount && safetyLoop < 1000) {
      safetyLoop++;

      // 주말 및 공휴일 예외 체크
      bool isWeekend =
          currentStart.weekday == DateTime.saturday ||
          currentStart.weekday == DateTime.sunday;
      bool isHoliday = holidays.any(
        (h) =>
            h.year == currentStart.year &&
            h.month == currentStart.month &&
            h.day == currentStart.day,
      );

      if ((_weekendException && isWeekend) ||
          (_holidayException && isHoliday)) {
        // 다음 날짜로 이동
        currentStart = _getNextDate(currentStart);
        currentEnd = _getNextDate(currentEnd);
        continue;
      }

      // Payload 작성
      payloads.add({
        'calendar_id': _scheduleFromEdit.calendarId, // 기존 캘린더 ID 유지
        'title': _title.trim(),
        'emotion_tag': _emotionTag,
        'color_value': _colorValue,
        'started_at': currentStart.toUtc().toIso8601String(),
        'ended_at': currentEnd.toUtc().toIso8601String(),
        'is_repeat': true,
        'repeat_option': _repeatOption,
        'repeat_num': _repeatNum,
        'repeat_count': _repeatCount,
        'repeat_group_id': groupId,
        'weekend_exception': _weekendException,
        'holiday_exception': _holidayException,
        'address': _address,
        'latitude': _latitude,
        'longitude': _longitude,
        'memo': _memo.trim().isEmpty ? null : _memo.trim(),
        'is_done': false, // 재생성 시 기본 미완료 처리 (기획에 따라 변경 가능)
      });

      createdCount++;
      currentStart = _getNextDate(currentStart);
      currentEnd = _getNextDate(currentEnd);
    }

    return payloads;
  }

  /// 주기 옵션에 따라 다음 날짜를 계산하는 헬퍼 함수
  DateTime _getNextDate(DateTime date) {
    switch (_repeatOption) {
      case 'daily':
        return date.add(Duration(days: _repeatNum));
      case 'weekly':
        return date.add(Duration(days: 7 * _repeatNum));
      case 'monthly':
        return DateTime(
          date.year,
          date.month + _repeatNum,
          date.day,
          date.hour,
          date.minute,
        );
      default:
        return date.add(Duration(days: _repeatNum));
    }
  }

  // 주소 관련 로직
  Future<void> updateLocationAction(String newAddress) async {
    try {
      final response = await supabase.functions.invoke(
        'hyper-endpoint',
        body: {'type': 'geocode', 'address': newAddress},
      );
      if (response.data == null) return;
      _address = newAddress;
      _latitude = response.data['latitude'].toString();
      _longitude = response.data['longitude'].toString();
      addressController.text = newAddress;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ geocode error: $e");
    }
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
