import 'package:dutytable/features/schedule/data/datasources/schedule_data_source.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:flutter/material.dart';

// class ScheduleEditViewModel extends ChangeNotifier {
//   final ScheduleModel _scheduleDetail;
//
//   ViewState _state = ViewState.idle;
//
//   final int _scheduleId;
//   String? _emotionTag;
//   String _colorValue = "0xFFFF3B30";
//   String _title = "";
//   bool _isDone = false;
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now();
//   TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 0);
//   TimeOfDay _endTime = const TimeOfDay(hour: 8, minute: 0);
//   bool _isRepeat = false;
//   String _repeatOption = "daily";
//   int _repeatNum = 1;
//   bool _weekendException = false;
//   bool _holidayException = false;
//   String? _address;
//   String? _longitude;
//   String? _latitude;
//   String _memo = "";
//
//   /// getter
//   ViewState get state => _state;
//   ScheduleModel get scheduleDetail => _scheduleDetail;
//   int get scheduleId => _scheduleId;
//   String? get emotionTag => _emotionTag;
//   String get colorValue => _colorValue;
//   String get title => _title;
//   bool get isDone => _isDone;
//   DateTime get startDate => _startDate;
//   DateTime get endDate => _endDate;
//   TimeOfDay get startTime => _startTime;
//   TimeOfDay get endTime => _endTime;
//   bool get isRepeat => _isRepeat;
//   String get repeatOption => _repeatOption;
//   int get repeatNum => _repeatNum;
//   bool get weekendException => _weekendException;
//   bool get holidayException => _holidayException;
//   String? get address => _address;
//   String? get longitude => _longitude;
//   String? get latitude => _latitude;
//   String get memo => _memo;
//
//   /// setter
//   set selectedEmotion(String? value) {
//     _emotionTag = value;
//     notifyListeners();
//   }
//
//   set selectedColor(String value) {
//     _colorValue = value;
//     notifyListeners();
//   }
//
//   void setTitle(String value) {
//     _title = value;
//     notifyListeners();
//   }
//
//   void setIsDone(bool value) {
//     _isDone = value;
//     notifyListeners();
//   }
//
//   set startDate(DateTime value) {
//     _startDate = value;
//     notifyListeners();
//   }
//
//   set endDate(DateTime value) {
//     _endDate = value;
//     notifyListeners();
//   }
//
//   set startTime(TimeOfDay value) {
//     _startTime = value;
//     notifyListeners();
//   }
//
//   set endTime(TimeOfDay value) {
//     _endTime = value;
//     notifyListeners();
//   }
//
//   set isRepeat(bool value) {
//     _isRepeat = value;
//     notifyListeners();
//   }
//
//   set repeatOption(String value) {
//     _repeatOption = value;
//     notifyListeners();
//   }
//
//   set repeatNum(int value) {
//     _repeatNum = value;
//     notifyListeners();
//   }
//
//   set weekendException(bool value) {
//     _weekendException = value;
//     notifyListeners();
//   }
//
//   set holidayException(bool value) {
//     _holidayException = value;
//     notifyListeners();
//   }
//
//   void setMemo(String value) {
//     if (value.length <= 300) {
//       _memo = value;
//       notifyListeners();
//     }
//   }
//
//   ScheduleEditViewModel({required ScheduleModel scheduleDetail})
//     : _scheduleDetail = scheduleDetail,
//       _scheduleId = scheduleDetail.id,
//       _emotionTag = scheduleDetail.emotionTag,
//       _colorValue = scheduleDetail.colorValue,
//       _title = scheduleDetail.title,
//       _isDone = scheduleDetail.isDone,
//       _address = scheduleDetail.address,
//       _longitude = scheduleDetail.longitude,
//       _latitude = scheduleDetail.latitude,
//       _isRepeat = scheduleDetail.isRepeat,
//       _repeatOption = scheduleDetail.repeatOption ?? 'daily',
//       _repeatNum = scheduleDetail.repeatNum ?? 1,
//       _weekendException = scheduleDetail.weekendException ?? false,
//       _holidayException = scheduleDetail.holidayException ?? false,
//       _memo = scheduleDetail.memo ?? "" {
//     final start = scheduleDetail.startedAt;
//     final end = scheduleDetail.endedAt;
//     _startDate = DateTime(start.year, start.month, start.day);
//     _endDate = DateTime(end.year, end.month, end.day);
//     _startTime = TimeOfDay(hour: start.hour, minute: start.minute);
//     _endTime = TimeOfDay(hour: end.hour, minute: end.minute);
//   }
//   Future<void> updateSchedule() async {
//     _state = ViewState.loading;
//     notifyListeners();
//     DateTime startedAt() => DateTime(
//       _startDate.year,
//       _startDate.month,
//       _startDate.day,
//       _startTime.hour,
//       _startTime.minute,
//     );
//     DateTime endedAt() => DateTime(
//       _endDate.year,
//       _endDate.month,
//       _endDate.day,
//       _endTime.hour,
//       _endTime.minute,
//     );
//     try {
//       final payload = {
//         'calendar_id': scheduleDetail.calendarId,
//         'title': _title.trim(),
//         'emotion_tag': _emotionTag,
//         'color_value': _colorValue,
//         'is_done': _isDone,
//         'started_at': startedAt().toUtc().toIso8601String(),
//         'ended_at': endedAt().toUtc().toIso8601String(),
//         'is_repeat': _isRepeat,
//         'repeat_option': _isRepeat ? _repeatOption : null,
//         'repeat_num': _isRepeat ? _repeatNum : null,
//         'weekend_exception': _isRepeat ? weekendException : false,
//         'holiday_exception': _isRepeat ? holidayException : false,
//         'address': _address,
//         'latitude': _latitude,
//         'longitude': _longitude,
//         'memo': _memo.trim().isEmpty ? null : _memo.trim(),
//       };
//       await ScheduleDataSource.instance.updateSchedule(
//         scheduleId: scheduleId,
//         payload: payload,
//       );
//       _state = ViewState.success;
//     } catch (e) {
//       _state = ViewState.error;
//       debugPrint('❌ updateSchedule error: $e');
//     } finally {
//       notifyListeners();
//     }
//   }
// }

enum EditViewState { idle, loading, success, error }

class ScheduleEditViewModel extends ChangeNotifier {
  final ScheduleModel _scheduleFromEdit;

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

  String? _address;
  String? _latitude;
  String? _longitude;
  String _memo = "";

  /// ===== getter =====
  int get scheduleId => _scheduleFromEdit.id;
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

  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String get memo => _memo;

  /// ===== constructor =====
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

    _address = schedule.address;
    _latitude = schedule.latitude;
    _longitude = schedule.longitude;
    _memo = schedule.memo ?? "";
  }

  /// ===== setters =====
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

  void _set(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  /// ===== update =====
  Future<void> updateSchedule() async {
    _state = EditViewState.loading;
    notifyListeners();

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

    try {
      await ScheduleDataSource.instance.updateSchedule(
        scheduleId: scheduleId,
        payload: {
          'title': _title.trim(),
          'emotion_tag': _emotionTag,
          'color_value': _colorValue,
          'is_done': _isDone,
          'started_at': startedAt.toUtc().toIso8601String(),
          'ended_at': endedAt.toUtc().toIso8601String(),
          'is_repeat': _isRepeat,
          'repeat_option': _isRepeat ? _repeatOption : null,
          'repeat_num': _isRepeat ? _repeatNum : null,
          'weekend_exception': _weekendException,
          'holiday_exception': _holidayException,
          'address': _address,
          'latitude': _latitude,
          'longitude': _longitude,
          'memo': _memo.trim().isEmpty ? null : _memo.trim(),
        },
      );

      _state = EditViewState.success;
    } catch (e) {
      _state = EditViewState.error;
      debugPrint('❌ updateSchedule error: $e');
    } finally {
      notifyListeners();
    }
  }
}
