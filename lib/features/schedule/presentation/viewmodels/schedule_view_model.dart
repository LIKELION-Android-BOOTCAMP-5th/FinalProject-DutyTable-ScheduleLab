import 'package:dutytable/core/services/supabase_manager.dart';
import 'package:dutytable/features/home_widget/domain/usecases/sync_all_calendars_to_widget_use_case.dart';
import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:dutytable/features/schedule/domain/usecases/delete_all_schedules_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/fetch_all_shared_schedules_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/fetch_my_schedules_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/fetch_schedules_use_case.dart';
import 'package:dutytable/features/schedule/domain/usecases/sync_google_calendar_to_schedule_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/di/injection.dart';
import '../../../calendar/domain/entities/calendar_entity.dart';
import '../../../calendar/domain/usecases/read_google_calendar_connection_use_case.dart';

/// 스케쥴 뷰모델
@injectable
class ScheduleViewModel extends ChangeNotifier {
  //-------------------- UseCase --------------------

  final ReadGoogleCalendarConnectionUseCase
  _readGoogleCalendarConnectionUseCase =
      getIt<ReadGoogleCalendarConnectionUseCase>();

  final SyncAllCalendarsToWidgetUseCase _syncAllCalendarsToWidgetUseCase =
      getIt<SyncAllCalendarsToWidgetUseCase>();

  final SyncGoogleCalendarToScheduleUseCase
  _syncGoogleCalendarToScheduleUseCase;

  final FetchSchedulesUseCase _fetchSchedules;
  final FetchMySchedulesUseCase _fetchMySchedules;
  final FetchAllSharedSchedulesUseCase _fetchAllSharedSchedules;
  final DeleteAllSchedulesUseCase _deleteAllSchedules;

  //-------------------- Entity --------------------

  final CalendarEntity? _calendar;

  CalendarEntity? get calendar => _calendar;

  final String _currentUserId =
      SupabaseManager.shared.supabase.auth.currentUser?.id ?? "";
  String get currentUserId => _currentUserId;

  //-------------------- UI --------------------

  List<ScheduleEntity> _schedules = [];
  List<ScheduleEntity> _mySchedules = [];
  List<DateTime?> _scheduleDates = [];
  List<ScheduleEntity> _allSharedSchedules = [];
  List<ScheduleEntity> _selectedFilteringList = [];
  bool _isShowMySchedule = false;
  bool _isShowAllSchedule = false;
  final Set<String> _selectedIds = {};
  bool _deleteMode = false;

  static const int startYear = 2000;
  static const int endYear = 2100;

  final List<int> filterYears = [for (int i = startYear; i <= endYear; i++) i];
  final List<int> filterMonths = [for (int i = 1; i <= 12; i++) i];
  final List<String> filterColors = const [
    '전체',
    '0xFFFF3B30',
    '0xFFFF9500',
    '0xFFFFCC00',
    '0xFF34C759',
    '0xFF32ADE6',
    '0xFF007AFF',
    '0xFFAF52DE',
  ];

  int? selectedFilterYears;
  int? selectedFilterMonth;
  String selectedFilterColor = "전체";
  DateTime selectedDay = DateTime.now();

  //-------------------- Getters --------------------

  List<ScheduleEntity> get schedules => _schedules;
  List<ScheduleEntity> get mySchedules => _mySchedules;
  List<DateTime?> get scheduleDates => _scheduleDates;
  List<ScheduleEntity> get allSharedSchedules => _allSharedSchedules;
  List<ScheduleEntity> get selectedFilteringList => _selectedFilteringList;
  bool get isShowMySchedule => _isShowMySchedule;
  bool get isShowAllSchedule => _isShowAllSchedule;
  Set<String> get selectedIds => _selectedIds;
  bool get deleteMode => _deleteMode;

  /// 실제로 화면(캘린더)에 그려질 일정 리스트
  List<ScheduleEntity> get displaySchedules {
    List<ScheduleEntity> combined = [];

    // 1. 현재 들어와 있는 캘린더의 일정 추가
    combined.addAll(_schedules);

    // 2. 내 개인 일정 토글 시 추가
    if (_isShowMySchedule) {
      combined.addAll(_mySchedules);
    }

    // 3. 모든 공유 일정 토글 시 추가
    if (_isShowAllSchedule) {
      combined.addAll(_allSharedSchedules);
    }

    // ID 중복 제거 (여러 리스트에 같은 일정이 있을 경우 대비)
    final ids = <String>{};
    combined.retainWhere((s) => ids.add(s.id.toString()));

    combined.sort((a, b) => a.startedAt.compareTo(b.startedAt));
    return combined;
  }

  //-------------------- Constructor --------------------

  ScheduleViewModel(
    this._fetchSchedules,
    this._fetchMySchedules,
    this._fetchAllSharedSchedules,
    this._deleteAllSchedules,
    this._syncGoogleCalendarToScheduleUseCase,
    @factoryParam CalendarEntity calendar,
  ) : _calendar = calendar {
    selectedFilterYears = DateTime.now().year;
    selectedFilterMonth = DateTime.now().month;
    _init();
  }

  // -------------------- Init --------------------

  /// 초기화 함수
  Future<void> _init() async {
    if (_calendar == null) return;

    try {
      await fetchSchedules();
      _mySchedules = await _fetchMySchedules();
      _allSharedSchedules = await _fetchAllSharedSchedules();
      _scheduleDates = _schedules
          .map(
            (e) =>
                DateTime(e.startedAt.year, e.startedAt.month, e.startedAt.day),
          )
          .toList();

      applyFilter();
    } catch (e) {
      debugPrint('❌ Schedule load error: $e');
    }
  }

  // -------------------- Fetch --------------------

  Future<void> fetchSchedules() async {
    if (_calendar == null) {
      return;
    }
    try {
      _schedules = await _fetchSchedules(_calendar.id);

      final userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
      if (userId != null) {
        final isGoogleConnected = await _readGoogleCalendarConnectionUseCase();

        if (isGoogleConnected) {
          final googleSchedules = await _syncGoogleCalendarToScheduleUseCase();

          if (googleSchedules.isNotEmpty) {
            final convertedSchedules = <ScheduleEntity>[];

            for (var scheduleMap in googleSchedules) {
              try {
                final startedAtStr = scheduleMap['started_at'];
                final endedAtStr = scheduleMap['ended_at'];

                if (startedAtStr == null || endedAtStr == null) {
                  continue;
                }

                final schedule = ScheduleEntity(
                  id:
                      DateTime.now().millisecondsSinceEpoch +
                      convertedSchedules.length,
                  calendarId: _calendar.id,
                  title: scheduleMap['title'],
                  colorValue:
                      scheduleMap['color_value']?.toString() ?? '0xFF4285F4',
                  isDone: false,
                  startedAt: DateTime.parse(startedAtStr).toLocal(),
                  endedAt: DateTime.parse(endedAtStr).toLocal(),
                  isRepeat: false,
                  createdAt: DateTime.now(),
                  memo: scheduleMap['memo'],
                  emotionTag: "😐",
                );

                convertedSchedules.add(schedule);
              } catch (e) {
                debugPrint("Google 일정 변환 실패: $e");
                continue;
              }
            }

            _schedules.addAll(convertedSchedules);
          }
        }
      }

      _scheduleDates = _schedules
          .map(
            (e) =>
                DateTime(e.startedAt.year, e.startedAt.month, e.startedAt.day),
          )
          .toList();

      await _syncAllCalendarsToWidgetUseCase();
      applyFilter();
    } catch (e) {
      debugPrint("❌ fetchSchedules error: $e");
    }
  }

  Future<void> fetchMySchedules() async {
    _mySchedules = await _fetchMySchedules();
    applyFilter();
  }

  Future<void> fetchAllSharedSchedules() async {
    _allSharedSchedules = await _fetchAllSharedSchedules();
    applyFilter();
  }

  // -------------------- Delete --------------------

  Future<void> deleteAllSchedules() async {
    try {
      await _deleteAllSchedules(_selectedIds);

      await Future.wait([
        fetchSchedules(),
        fetchMySchedules(),
        fetchAllSharedSchedules(),
      ]);

      _selectedIds.clear();
      _deleteMode = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ deleteAllSchedules error: $e');
      rethrow;
    }
  }

  //-------------------------- Filters ------------------------

  /// 일정 목록 필터링
  void applyFilter() {
    _selectedFilteringList = displaySchedules.where((schedule) {
      final startedAt = schedule.startedAt;
      final isYearMatch =
          selectedFilterYears == null || startedAt.year == selectedFilterYears;
      final isMonthMatch =
          selectedFilterMonth == null || startedAt.month == selectedFilterMonth;
      final isColorMatch =
          selectedFilterColor == "전체" ||
          schedule.colorValue == selectedFilterColor;

      return isYearMatch && isMonthMatch && isColorMatch;
    }).toList();

    // 시간순 정렬
    _selectedFilteringList.sort((a, b) {
      // 1차 기준: 시작 시간
      int compare = a.startedAt.compareTo(b.startedAt);
      if (compare != 0) return compare;

      // 2차 기준: 시작 시간이 같다면 제목 순 정렬
      return a.title.compareTo(b.title);
    });

    notifyListeners();
  }

  /// 필터 연도 선택
  void selectedYear(int value) {
    selectedFilterYears = value;
    applyFilter();
  }

  /// 필터 월 선택
  void selectedMonth(int value) {
    selectedFilterMonth = value;
    applyFilter();
  }

  /// 필터 컬러 선택
  void selectedColor(String value) {
    selectedFilterColor = value;
    applyFilter();
  }

  /// 캘린더 날짜 선택
  void changeSelectedDay(DateTime select) {
    selectedDay = select;
    notifyListeners();
  }

  //---------------------------- Toggle ----------------------------

  /// 내 일정 불러오기 모드
  void toggleFetchMySchedule() {
    _isShowMySchedule = !_isShowMySchedule;
    applyFilter();
    notifyListeners();
  }

  /// 모든 일정 불러오기 모드
  void toggleFetchAllSchedule() {
    _isShowAllSchedule = !_isShowAllSchedule;
    applyFilter();
    notifyListeners();
  }

  //---------------------------- selected / deleted ----------------------------

  /// 특정 카드가 선택됐는지 여부
  bool isSelected(String id) {
    return _selectedIds.contains(id);
  }

  /// 특정 카드 선택 토글
  void toggleSelected(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  /// 선택 삭제 모드
  void toggleDeleteMode() {
    _deleteMode = !_deleteMode;
    notifyListeners();
  }

  /// 선택 삭제 모드 취소
  void cancelDeleteMode() {
    _deleteMode = false;
    selectedIds.clear();
    notifyListeners();
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
