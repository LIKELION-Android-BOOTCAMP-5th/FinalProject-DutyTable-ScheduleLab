import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/usecases/delete_schedules_by_group_id_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/delete_schedules_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/fetch_schedule_by_id_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

enum DetailViewState { loading, success, error, deleted }

@injectable
class ScheduleDetailViewModel extends ChangeNotifier {
  //-------------------- UseCase --------------------

  final FetchScheduleByIdUseCase _fetchScheduleByIdUseCase;
  final DeleteSchedulesUseCase _deleteSchedulesUseCase;
  final DeleteSchedulesByGroupIdUseCase _deleteSchedulesByGroupIdUseCase;

  //-------------------- Entity --------------------

  ScheduleEntity? _schedule;

  //-------------------- UI --------------------

  DetailViewState _state = DetailViewState.loading;

  //-------------------- Fields --------------------

  final int _scheduleId;
  final bool _isAdmin;
  bool _disposed = false;

  //-------------------- Getter --------------------

  DetailViewState get state => _state;

  int get scheduleId => _scheduleId;
  bool get isAdmin => _isAdmin;

  ScheduleEntity? get schedule => _schedule;

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

  /// 제외된 날짜 리스트 게터
  List<String> get excludedDates => _schedule?.excludedDates ?? [];
  //-------------------- Constructor --------------------

  ScheduleDetailViewModel(
    this._fetchScheduleByIdUseCase,
    this._deleteSchedulesUseCase,
    this._deleteSchedulesByGroupIdUseCase,
    @factoryParam int scheduleId,
    @factoryParam bool isAdmin,
  ) : _scheduleId = scheduleId,
      _isAdmin = isAdmin {
    fetchUpdatedSchedule();
  }

  Future<void> fetchUpdatedSchedule() async {
    _state = DetailViewState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _schedule = await _fetchScheduleByIdUseCase(_scheduleId);

      _state = DetailViewState.success;
    } catch (e) {
      _schedule = null;
      _state = DetailViewState.deleted;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteSchedule() async {
    await _deleteSchedulesUseCase(_scheduleId);
    _state = DetailViewState.deleted;
    notifyListeners();
  }

  Future<void> deleteRepeatGroup() async {
    final groupId = _schedule?.repeatGroupId;
    if (groupId == null) return;

    try {
      await _deleteSchedulesByGroupIdUseCase(groupId);

      _schedule = null;
      _state = DetailViewState.deleted;

      notifyListeners();
    } catch (e) {
      _state = DetailViewState.error;
      debugPrint('❌ 그룹 삭제 에러: $e');
      notifyListeners();
    }
  }

  Future<void> shareSchedule() async {
    if (_schedule == null) return;

    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');

    String content = "📅 [일정 공유: $title]\n\n";

    if (startedAt != null && endedAt != null) {
      content +=
          "⏰ 시간: ${dateFormat.format(startedAt!)} ~ ${dateFormat.format(endedAt!)}\n";
    }

    if (address != null && address!.isNotEmpty) {
      content += "📍 장소: $address\n";
    }

    if (memo.isNotEmpty) {
      content += "📝 메모: $memo\n";
    }

    content += "\nFrom. DutyTable";

    try {
      await Share.share(content, subject: title);
    } catch (e) {
      debugPrint('❌ 공유하기 에러: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }
}
