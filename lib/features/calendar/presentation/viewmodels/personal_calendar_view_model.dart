import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/calendar_data_source.dart';

class PersonalCalendarViewModel extends ChangeNotifier {
  /// 개인 캘린더 뷰모델
  PersonalCalendarViewModel() {
    _init();
  }

  /// 개인 캘린더 탭 이름 리스트(private)
  final List<String> _tabNames = ["캘린더", "리스트", "나와의 채팅"];

  /// 개인 캘린더 탭 이름 리스트(public)
  List<String> get tabNames => _tabNames;

  /// 탭 갯수(public) = 탭 이름 리스트 길이
  int get tabLength => _tabNames.length;

  /// 현재 선택 된 탭의 인덱스(private)
  int _currentIndex = 0;

  /// 현재 선택 된 탭의 인덱스(public)
  int get currentIndex => _currentIndex;

  /// 캘린더 데이터(private)
  CalendarModel? _calendarResponse;

  /// 캘린더 데이터(public)
  CalendarModel? get calendarResponse => _calendarResponse;

  void _init() {
    fetchCalendar();
  }

  /// 개인 캘린더 정보 가져오기
  Future<void> fetchCalendar() async {
    _calendarResponse = await CalendarDataSource.shared.fetchPersonalCalendar();
    notifyListeners();
  }
}
