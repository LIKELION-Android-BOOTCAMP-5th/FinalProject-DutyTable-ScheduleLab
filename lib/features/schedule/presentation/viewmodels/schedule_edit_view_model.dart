import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/usecases/add_schedule_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/delete_schedules_by_group_id_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/fetch_holidays_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/geocode_address_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/update_schedule_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum EditViewState { idle, loading, success, error }

@injectable
class ScheduleEditViewModel extends ChangeNotifier {
  //-------------------- UseCase --------------------

  final AddScheduleUseCase _addScheduleUseCase;
  final FetchHolidaysUseCase _fetchHolidaysUseCase;
  final UpdateScheduleUseCase _updateSchedule;
  final DeleteSchedulesByGroupIdUseCase _deleteSchedulesByGroupIdUseCase;
  final GeocodeAddressUseCase _geocodeAddress;

  //-------------------- Entity --------------------

  final ScheduleEntity _scheduleFromEdit;

  //-------------------- UI --------------------

  final TextEditingController addressController = TextEditingController();

  EditViewState _state = EditViewState.idle;

  //-------------------- Fields --------------------

  late String _title;
  late String _emotionTag;
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
  List<DateTime> _excludedDates = [];
  late String _endOption;
  late DateTime _endDateForRepeat;

  //-------------------- Getters --------------------

  EditViewState get state => _state;
  int get scheduleId => _scheduleFromEdit.id;
  String? get repeatGroupId => _scheduleFromEdit.repeatGroupId;
  String get title => _title;
  String get emotionTag => _emotionTag;
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
  List<DateTime> get excludedDates => _excludedDates;
  String get endOption => _endOption;
  DateTime get endDateForRepeat => _endDateForRepeat;

  //-------------------- Constructor --------------------

  ScheduleEditViewModel(
    this._addScheduleUseCase,
    this._fetchHolidaysUseCase,
    this._updateSchedule,
    this._deleteSchedulesByGroupIdUseCase,
    this._geocodeAddress,
    @factoryParam ScheduleEntity schedule,
  ) : _scheduleFromEdit = schedule {
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
    // [추가] String 리스트를 DateTime 리스트로 변환하여 초기화
    _excludedDates =
        schedule.excludedDates?.map((dateStr) {
          return DateTime.parse(dateStr);
        }).toList() ??
        [];
    // [보완] 기존 데이터의 종료 옵션 판단 (repeatCount가 있으면 'count', 없으면 'date' 등 서비스 기획에 맞춰 설정)
    _endOption = "count";
    _endDateForRepeat = DateTime.now().add(const Duration(days: 30));

    _address = schedule.address;
    _latitude = schedule.latitude;
    _longitude = schedule.longitude;
    _memo = schedule.memo ?? "";
    addressController.text = _address ?? "";
  }

  //-------------------- Setters --------------------

  void _set(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  void setEmotion(String v) => _set(() => _emotionTag = v);
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

  /// 제외 날짜 추가
  void addExcludedDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (!_excludedDates.contains(dateOnly)) {
      _excludedDates.add(dateOnly);
      _excludedDates.sort();
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
      // jumpToNextWorkingDay 등의 확장 함수를 활용해 다음 일정 날짜로 이동
      // (이 로직은 프로젝트의 extensions.dart에 정의된 jump 로직과 동일해야 함)
      count++;
      tempDate = tempDate.jumpToNextWorkingDay(
        repeatOption: _repeatOption,
        repeatNum: _repeatNum,
        holidays: [], // 정확한 계산을 위해 필요시 holidays fetch 로직 연동
        weekendException: _weekendException,
        holidayException: _holidayException,
      );
    }
    _repeatCount = count > 0 ? count : 1;
  }

  //-------------------- Update --------------------

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
      if (isAll && repeatGroupId != null) {
        // 1. 기존 그룹 삭제
        await _deleteSchedulesByGroupIdUseCase(repeatGroupId!);

        // 2. 엣지 펑션용 페이로드 생성 (ScheduleAddViewModel과 동일한 규격)
        final Map<String, dynamic> payload = {
          'calendarId': _scheduleFromEdit.calendarId,
          'title': _title.trim(),
          'emotionTag': _emotionTag,
          'colorValue': _colorValue,
          'isDone': _isDone,
          'startDate': _startDate.toIso8601String().split('T')[0],
          'startTime':
              '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
          'endTime':
              '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
          'isRepeat': _isRepeat,
          'repeatOption': _isRepeat ? _repeatOption : 'none',
          'repeatNum': _isRepeat ? _repeatNum : 1,
          'repeatCount': _isRepeat ? _repeatCount : 1,
          'weekendException': _weekendException,
          'holidayException': _holidayException,
          'excludedDates': _excludedDates
              .map((d) => d.toIso8601String().split('T')[0])
              .toList(),
          'address': _address,
          'latitude': _latitude,
          'longitude': _longitude,
          'memo': _memo.trim().isEmpty ? null : _memo.trim(),
          'excludedDates': _excludedDates
              .map(
                (d) =>
                    "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}",
              )
              .toList(),
        };

        // 3. 엣지 펑션을 호출하여 새 그룹 생성
        await _addScheduleUseCase(payload);
      } else {
        // 단건 수정 로직 (기존 유지)
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

        final singlePayload = {
          'title': _title.trim(),
          'emotion_tag': _emotionTag,
          'color_value': _colorValue,
          'started_at': startedAt.toUtc().toIso8601String(),
          'ended_at': endedAt.toUtc().toIso8601String(),
          'is_repeat': _isRepeat,
          'address': _address,
          'latitude': _latitude,
          'longitude': _longitude,
          'memo': _memo.trim().isEmpty ? null : _memo.trim(),
          'is_done': _isDone,
        };
        await _updateSchedule(scheduleId, singlePayload);
      }

      _state = EditViewState.success;
    } catch (e) {
      _state = EditViewState.error;
      debugPrint('❌ update error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> _generateNewSchedules(
    String groupId,
  ) async {
    List<Map<String, dynamic>> payloads = [];

    List<DateTime> holidays = [];
    if (_holidayException) {
      holidays = await _fetchHolidaysUseCase(_startDate.year);
    }

    final scheduleDuration = DateTime(
      2000,
      1,
      1,
      _endTime.hour,
      _endTime.minute,
    ).difference(DateTime(2000, 1, 1, _startTime.hour, _startTime.minute));

    DateTime currentStart = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
    );
    int createdCount = 0;
    int safetyLoop = 0;

    while (createdCount < _repeatCount && safetyLoop < 3000) {
      safetyLoop++;

      // 1. 사용자가 직접 추가한 제외 날짜 리스트에 포함되는지 확인
      bool isExcludedByUser = _excludedDates.any(
        (d) =>
            d.year == currentStart.year &&
            d.month == currentStart.month &&
            d.day == currentStart.day,
      );

      // 2. 사용자 제외 날짜이거나 주말/공휴일 예외인 경우 건너뛰기
      if (isExcludedByUser ||
          currentStart.checkIsException(
            holidays: holidays,
            weekendException: _weekendException,
            holidayException: _holidayException,
          )) {
        currentStart = currentStart.add(const Duration(days: 1));
        continue;
      }

      DateTime startDateTime = DateTime(
        currentStart.year,
        currentStart.month,
        currentStart.day,
        _startTime.hour,
        _startTime.minute,
      );

      payloads.add({
        'calendar_id': _scheduleFromEdit.calendarId,
        'title': _title.trim(),
        'emotion_tag': _emotionTag,
        'color_value': _colorValue,
        'started_at': startDateTime.toUtc().toIso8601String(),
        'ended_at': startDateTime
            .add(scheduleDuration)
            .toUtc()
            .toIso8601String(),
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
        'is_done': false,
      });

      createdCount++;

      currentStart = currentStart.jumpToNextWorkingDay(
        repeatOption: _repeatOption,
        repeatNum: _repeatNum,
        holidays: holidays,
        weekendException: _weekendException,
        holidayException: _holidayException,
      );
    }

    return payloads;
  }

  //------------------------ Location ------------------------

  /// 주소 관련 로직
  Future<void> updateLocationAction(String newAddress) async {
    try {
      final response = await _geocodeAddress(newAddress);
      _address = newAddress;
      _latitude = response.latitude;
      _longitude = response.longitude;
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
