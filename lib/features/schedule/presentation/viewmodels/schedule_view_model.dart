import 'package:dutytable/core/services/supabase_manager.dart';
import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/schedule/data/datasources/schedule_data_source.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:flutter/material.dart';

import '../../../calendar/data/datasources/calendar_data_source.dart';
import '../../../calendar/data/models/calendar_model.dart';
import '../../../home_widget/data/datasources/widget_local_data_source.dart';

/// 스케쥴 뷰모델
class ScheduleViewModel extends ChangeNotifier {
  /// 현재 캘린더 데이터(private)
  final CalendarModel? _calendar;

  /// 현재 캘린더 데이터(puclic)
  CalendarModel? get calendar => _calendar;

  final String _currentUserId =
      SupabaseManager.shared.supabase.auth.currentUser?.id ?? "";
  String get currentUserId => _currentUserId;

  /// 불러온 일정 리스트(private) - 전체 목록
  List<ScheduleModel> _schedules = [];

  /// 불러온 일정 리스트(public)
  List<ScheduleModel> get schedules => _schedules;

  /// 내 일정 리스트(private)
  List<ScheduleModel> _mySchedules = [];

  /// 내 일정 리스트(public)
  List<ScheduleModel> get mySchedules => _mySchedules;

  /// 내가 속한 모든 공유 캘린더의 일정 리스트(private)
  List<ScheduleModel> _allSharedSchedules = [];

  /// 일정 날짜만 담을 리스트(private)
  List<DateTime?> _scheduleDate = [];

  /// 일정 날짜만 담을 리스트(public)
  List<DateTime?> get scheduleDate => _scheduleDate;

  /// 필터 드롭다운 버튼 시작 년도
  static const int startYear = 2000;

  /// 필터 드롭다운 버튼 종료 년도
  static const int endYear = 2100;

  /// 필터 드롭다운 연도 리스트(private)
  List<int> _filterYears = [];

  /// 필터 드롭다운 연도 리스트(public)
  List<int> get filterYears => _filterYears;

  /// 선택된 필터 드롭다운 연도
  int? selectedFilterYears;

  /// 필터 드롭다운 월 리스트(private)
  List<int> _filterMonths = [];

  /// 필터 드롭다운 월 리스트(public)
  List<int> get filterMonths => _filterMonths;

  /// 선택된 필터 드롭다운 월
  int? selectedFilterMonth;

  /// 필터 드롭다운 컬러 리스트(private)
  List<String> _filterColors = [];

  /// 필터 드롭다운 컬러 리스트(public)
  List<String> get filterColors => _filterColors;

  /// 선택된 필터 드롭다운 컬러
  String selectedFilterColor = "전체";

  /// 내 캘린더 불러오기(private)
  bool _isShowMySchedule = false;

  /// 내 캘린더 불러오기(public)
  bool get isShowMySchedule => _isShowMySchedule;

  /// 모든 캘린더 불러오기(private)
  bool _isShowAllSchedule = false;

  /// 모든 캘린더 불러오기(public)
  bool get isShowAllSchedule => _isShowAllSchedule;

  /// 화면에 표시될 필터링된 일정 리스트(private)
  List<ScheduleModel> _selectedFilteringList = [];

  /// 화면에 표시될 필터링된 일정 리스트(public)
  List<ScheduleModel> get selectedFilteringList => _selectedFilteringList;

  /// 캘린더 선택된 날짜
  DateTime selectedDay = DateTime.now();

  /// 선택된 카드 id들
  final Set<String> _selectedIds = {};
  Set<String> get selectedIds => _selectedIds;

  /// 선택 삭제 모드
  bool _deleteMode = false;
  bool get deleteMode => _deleteMode;

  final _widgetDataSource = WidgetDataSourceImpl();

  /// 앱 실행될 때
  /// 초기화 함수 실행
  ScheduleViewModel({CalendarModel? calendar}) : _calendar = calendar {
    _init();
  }

  /// 실제로 화면(캘린더)에 그려질 일정 리스트
  List<ScheduleModel> get displaySchedules {
    List<ScheduleModel> combined = [];

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

  /// 내 일정 불러오기
  Future<void> fetchMySchedules() async {
    try {
      final List<ScheduleModel> rawSchedules = await ScheduleDataSource.instance
          .fetchMySchedules();

      _mySchedules = rawSchedules.map((schedule) {
        return schedule.copyWith(title: "[My] ${schedule.title}");
      }).toList();
    } catch (e) {
      debugPrint("내 일정 로드 실패: $e");
    } finally {
      notifyListeners();
    }
  }

  /// 모든 공유 캘린더 일정 불러오기
  Future<void> fetchAllSharedSchedules() async {
    try {
      final List<ScheduleModel> raw = await ScheduleDataSource.instance
          .fetchJoinedSharedSchedules();

      // 구분을 위해 타이틀 앞에 태그 추가 (선택 사항)
      _allSharedSchedules = raw
          .map((s) => s.copyWith(title: "[공유] ${s.title}"))
          .toList();
    } catch (e) {
      debugPrint("공유 일정 로드 실패: $e");
    } finally {
      notifyListeners();
    }
  }

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

  /// 초기화 함수
  _init() {
    _filterYears = [for (int year = startYear; year <= endYear; year++) year];

    _filterMonths = [for (int month = 1; month <= 12; month++) month];

    _filterColors = [
      '전체',
      '0xFFFF3B30',
      '0xFFFF9500',
      '0xFFFFCC00',
      '0xFF34C759',
      '0xFF32ADE6',
      '0xFF007AFF',
      '0xFFAF52DE',
    ];

    selectedFilterYears = DateTime.now().year;
    selectedFilterMonth = DateTime.now().month;
    fetchSchedules();
    fetchMySchedules();
    fetchAllSharedSchedules();
  }

  /// 캘린더 날짜 선택
  void changeSelectedDay(DateTime select) {
    selectedDay = select;
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

  /// 일정 목록 가져오기
  Future<void> fetchSchedules() async {
    if (_calendar == null) {
      return;
    }
    try {
      _schedules = await ScheduleDataSource.instance.fetchSchedules(
        _calendar.id,
      );

      final userId = SupabaseManager.shared.supabase.auth.currentUser?.id;
      if (userId != null) {
        final isGoogleConnected = await CalendarDataSource.instance
            .fetchIsGoogleCalendarConnection();

        if (isGoogleConnected) {
          final googleSchedules = await ScheduleDataSource.instance
              .syncGoogleCalendarToSchedule();

          if (googleSchedules.isNotEmpty) {
            final convertedSchedules = <ScheduleModel>[];

            for (var scheduleMap in googleSchedules) {
              try {
                final startedAtStr = scheduleMap['started_at'];
                final endedAtStr = scheduleMap['ended_at'];

                if (startedAtStr == null || endedAtStr == null) {
                  continue;
                }

                final schedule = ScheduleModel(
                  id:
                      DateTime.now().millisecondsSinceEpoch +
                      convertedSchedules.length,
                  calendarId: _calendar!.id,
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

      _scheduleDate = _schedules.map((e) => e.startedAt.toPureDate()).toList();

      await _widgetDataSource.syncAllCalendarsToWidget();
      applyFilter();
    } catch (e) {
      debugPrint("❌ fetchSchedules error: $e");
    }
  }

  /// 일정 목록 필터링
  void applyFilter() {
    final List<ScheduleModel> baseList = displaySchedules;

    _selectedFilteringList = baseList.where((schedule) {
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

  /// 일정 선택 삭제(다수 선택)
  Future<void> deleteAllSchedules() async {
    try {
      await ScheduleDataSource.instance.deleteAllSchedules(selectedIds);
      // 삭제 후 모든 데이터 리프레시
      await Future.wait([
        fetchSchedules(),
        fetchMySchedules(),
        fetchAllSharedSchedules(),
      ]);
    } catch (e) {
      rethrow;
    }
  }
}
