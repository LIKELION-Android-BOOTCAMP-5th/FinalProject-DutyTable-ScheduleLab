import 'package:dutytable/extensions.dart';
import 'package:dutytable/features/schedule/data/datasources/schedule_data_source.dart';
import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/supabase_manager.dart';
import 'package:flutter/material.dart';

import '../../../calendar/data/models/calendar_model.dart';

/// 스케쥴 뷰모델
class ScheduleViewModel extends ChangeNotifier {
  /// 현재 캘린더 데이터
  final CalendarModel? _calendar;
  CalendarModel? get calendar => _calendar;

  final String _currentUserId =
      SupabaseManager.shared.supabase.auth.currentUser?.id ?? "";
  String get currentUserId => _currentUserId;

  /// 불러온 일정 리스트(private)
  List<ScheduleModel> _schedules = [];

  /// 불러온 일정 리스트(public)
  List<ScheduleModel> get schedules => _schedules;

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

  /// 캘린더 선택된 날짜
  DateTime selectedDay = DateTime.now();

  /// 선택된 카드 id들
  final Set<String> _selectedIds = {};
  Set<String> get selectedIds => _selectedIds;

  /// 선택 삭제 모드
  bool _deleteMode = false;
  bool get deleteMode => _deleteMode;

  /// 앱 실행될 때
  /// 초기화 함수 실행
  ScheduleViewModel({CalendarModel? calendar}) : _calendar = calendar {
    // 매개변수 이름을 받은 후 _calendar에 할당
    _init();
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

    _filterColors = ['전체', 'Red', 'Blue', 'Green', 'Yellow', 'Purple'];

    selectedFilterYears = DateTime.now().year;
    selectedFilterMonth = DateTime.now().month;
    fetchSchedules();
  }

  /// 캘린더 날짜 선택
  void changeSelectedDay(DateTime select) {
    selectedDay = select;
    notifyListeners();
  }

  void selectedYear(int value) {
    selectedFilterYears = value;
    notifyListeners();
  }

  /// 일정 목록 가져오기
  Future<void> fetchSchedules() async {
    if (_calendar == null) {
      return;
    } else {
      try {
        _schedules = await ScheduleDataSource.shared.fetchSchedules(
          _calendar.id,
        );

        _scheduleDate = _schedules
            .map((e) => e.startedAt.toPureDate())
            .toList();
        notifyListeners();
      } catch (e) {
        debugPrint("❌ fetchSchedules error: $e");
      }
    }
  }

  /// 일정 선택 삭제(다수 선택)
  Future<void> deleteAllSchedules() async {
    try {
      await ScheduleDataSource().deleteAllSchedules(selectedIds);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
