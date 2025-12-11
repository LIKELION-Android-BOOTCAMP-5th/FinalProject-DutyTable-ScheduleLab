import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/calendar_data_source.dart';

enum ViewState { loading, success, error }

class PersonalCalendarViewModel extends ChangeNotifier {
  /// 데이터 로딩 상태(private)
  ViewState _state = ViewState.loading;

  /// 데이터 로딩 상태(public)
  ViewState get state => _state;

  /// 개인 캘린더 탭 이름 리스트(private)
  final List<String> _tabNames = ["캘린더", "리스트", "나와의 채팅"];

  /// 개인 캘린더 탭 이름 리스트(public)
  List<String> get tabNames => _tabNames;

  /// 에러 메세지(private)
  String? _errorMessage;

  /// 에러 메세지(public)
  String? get errorMessage => _errorMessage;

  /// 탭 갯수(public) = 탭 이름 리스트 길이
  int get tabLength => _tabNames.length;

  /// 캘린더 데이터(private)
  CalendarModel? _calendarResponse;

  /// 캘린더 데이터(public)
  CalendarModel? get calendarResponse => _calendarResponse;

  /// 개인 캘린더 뷰모델
  PersonalCalendarViewModel() {
    _init();
  }

  void _init() {
    fetchCalendar();
  }

  /// 개인 캘린더 정보 가져오기
  Future<void> fetchCalendar() async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      _calendarResponse = await CalendarDataSource.shared
          .fetchPersonalCalendar();
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
      debugPrint("Error loading calendars: $e");
    } finally {
      notifyListeners();
    }
  }
}
