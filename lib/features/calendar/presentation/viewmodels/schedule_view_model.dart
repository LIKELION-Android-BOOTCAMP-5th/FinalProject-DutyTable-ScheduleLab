import 'package:dutytable/task_model.dart';
import 'package:flutter/material.dart';

/// 스케쥴 뷰모델
class ScheduleViewModel extends ChangeNotifier {
  /// 불러온 일정 리스트(private)
  List<Task> _tasks = [];

  /// 불러온 일정 리스트(public)
  List<Task> get tasks => _tasks;

  /// 일정 날짜만 담을 리스트(private)
  List<DateTime?> _tasksDate = [];

  /// 일정 날짜만 담을 리스트(public)
  List<DateTime?> get tasksDate => _tasksDate;

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

  /// 앱 실행될 때
  /// 초기화 함수 실행
  ScheduleViewModel() {
    _init();
  }

  /// 초기화 함수
  _init() {
    _filterYears = [for (int year = startYear; year <= endYear; year++) year];

    _filterMonths = [for (int month = 1; month <= 12; month++) month];

    _filterColors = ['전체', 'Red', 'Blue', 'Green', 'Yellow', 'Purple'];

    selectedFilterYears = DateTime.now().year;
    selectedFilterMonth = DateTime.now().month;
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
}
