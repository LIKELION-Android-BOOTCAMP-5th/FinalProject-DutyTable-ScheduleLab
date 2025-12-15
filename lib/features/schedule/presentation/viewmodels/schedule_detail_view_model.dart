import 'package:dutytable/features/schedule/data/datasources/schedule_data_source.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class ScheduleDetailViewModel extends ChangeNotifier {
  final bool _isAdmin;
  bool get isAdmin => _isAdmin;

  final int _scheduleId;

  /// 일정 상세 - 제목
  final String _title;

  /// 일정 상세 - 감정 및 색
  final String? _emotionTag;
  final String _colorValue;

  /// 일정 상세 - 시작일(시작시간) / 종료일(종료시간)
  final DateTime _startedAt;
  final DateTime _endedAt;

  /// 일정 상세 - 완료
  bool _isDone = false;

  /// 일정 상세 - 지도
  String? _address;
  String? _longitude;
  String? _latitude;

  /// 일정 상세 - 반복
  bool _isRepeat = false;
  final int? _repeatNum;
  String _repeatOption = "day"; // day, week, month, year
  int _repeatCount = 1;
  bool _weekendException = false;
  bool _holidayException = false;

  /// 일정 상세 - 메모
  String _memo = "";

  ///  Getter
  int get scheduleId => _scheduleId;

  String get title => _title;

  String? get emotionTag => _emotionTag;

  String get colorValue => _colorValue;

  DateTime get startedAt => _startedAt;

  DateTime get endedAt => _endedAt;

  bool get isDone => _isDone;

  String? get address => _address;

  String? get longitude => _longitude;

  String? get latitude => _latitude;

  bool get isRepeat => _isRepeat;

  int? get repeatNum => _repeatNum;

  String get repeatOption => _repeatOption;

  int get repeatCount => _repeatCount;

  bool get weekendException => _weekendException;

  bool get holidayException => _holidayException;

  String get memo => _memo;

  /// Setter
  set isDone(bool value) {
    _isDone = value;
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

  set repeatCount(int value) {
    _repeatCount = value;
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

  set memo(String value) {
    if (_memo == value) return;
    _memo = value;
    notifyListeners();
  }

  ScheduleDetailViewModel({
    required ScheduleModel scheduleDetail,
    required bool isAdmin,
  }) : _isAdmin = isAdmin,
       _scheduleId = scheduleDetail.id,
       _title = scheduleDetail.title,
       _emotionTag = scheduleDetail.emotionTag,
       _colorValue = scheduleDetail.colorValue,
       _startedAt = scheduleDetail.startedAt,
       _endedAt = scheduleDetail.endedAt,
       _isDone = scheduleDetail.isDone,
       _address = scheduleDetail.address,
       _longitude = scheduleDetail.longitude,
       _latitude = scheduleDetail.latitude,
       _isRepeat = scheduleDetail.isRepeat,
       _repeatNum = scheduleDetail.repeatNum,
       _repeatOption = scheduleDetail.repeatOption ?? 'day',
       _repeatCount = scheduleDetail.repeatCount ?? 1,
       _weekendException = scheduleDetail.weekendException ?? false,
       _holidayException = scheduleDetail.holidayException ?? false,
       _memo = scheduleDetail.memo ?? "";

  void setAddress({
    required String address,
    required String latitude,
    required String longitude,
  }) {
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }

  Future<void> deleteSchedules(int scheduleId) async {
    try {
      await ScheduleDataSource().deleteSchedules(scheduleId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

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
}
