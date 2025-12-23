import 'package:dutytable/features/schedule/data/datasources/schedule_data_source.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

enum DetailViewState { idle, loading, success, error, deleted }

class ScheduleDetailViewModel extends ChangeNotifier {
  DetailViewState _state = DetailViewState.loading;

  final int _scheduleId;
  final bool _isAdmin;

  ScheduleModel? _schedule;

  ScheduleDetailViewModel({required int scheduleId, required bool isAdmin})
    : _scheduleId = scheduleId,
      _isAdmin = isAdmin {
    fetchUpdatedSchedule();
  }

  /// ===== Getter =====
  DetailViewState get state => _state;

  bool get isAdmin => _isAdmin;
  int get scheduleId => _scheduleId;

  ScheduleModel? get schedule => _schedule;

  bool get hasData => _schedule != null;

  String get title => _schedule?.title ?? '';
  String? get emotionTag => _schedule?.emotionTag;
  String get colorValue => _schedule?.colorValue ?? '';

  DateTime? get startedAt => _schedule?.startedAt;
  DateTime? get endedAt => _schedule?.endedAt;

  bool get isDone => _schedule?.isDone ?? false;

  bool get isRepeat => _schedule?.isRepeat ?? false;
  String get repeatOption => _schedule?.repeatOption ?? 'daily';
  int get repeatNum => _schedule?.repeatNum ?? 1;
  bool get weekendException => _schedule?.weekendException ?? false;
  bool get holidayException => _schedule?.holidayException ?? false;
  int get repeatCount => _schedule?.repeatCount ?? 1;

  String? get address => _schedule?.address;
  String? get latitude => _schedule?.latitude;
  String? get longitude => _schedule?.longitude;

  String get memo => _schedule?.memo ?? '';

  Future<void> fetchUpdatedSchedule() async {
    _state = DetailViewState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _schedule = await ScheduleDataSource.instance.fetchScheduleById(
        _scheduleId,
      );

      _state = DetailViewState.success;
    } catch (e) {
      _schedule = null;
      _state = DetailViewState.deleted;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteSchedule() async {
    await ScheduleDataSource.instance.deleteSchedules(_scheduleId);
    _state = DetailViewState.deleted;
    notifyListeners();
  }

  Future<void> deleteRepeatGroup() async {
    final groupId = _schedule?.repeatGroupId;
    if (groupId == null) return;

    try {
      await ScheduleDataSource.instance.deleteSchedulesByGroupId(groupId);

      _schedule = null;
      _state = DetailViewState.deleted;

      notifyListeners();
    } catch (e) {
      _state = DetailViewState.error;
      debugPrint('❌ 그룹 삭제 에러: $e');
      notifyListeners();
    }
  }
}
