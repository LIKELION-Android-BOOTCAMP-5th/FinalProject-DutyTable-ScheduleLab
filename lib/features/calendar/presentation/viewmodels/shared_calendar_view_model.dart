import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/supabase_manager.dart';
import 'package:flutter/material.dart';

enum ViewState { loading, success, error }

class SharedCalendarViewModel extends ChangeNotifier {
  /// 공유 캘린더 목록 뷰모델
  SharedCalendarViewModel() {
    _init();
  }

  /// 데이터 로딩 상태(private)
  ViewState _state = ViewState.loading;

  /// 데이터 로딩 상태(public)
  ViewState get state => _state;

  /// 에러 메세지(private)
  String? _errorMessage;

  /// 에러 메세지(public)
  String? get errorMessage => _errorMessage;

  bool deleteMode = false;
  bool isAdmin = false;

  /// 선택된 카드 id들
  final Set<String> selectedIds = {};

  /// 캘린더 데이터(private)
  List<CalendarModel>? _calendarResponse;

  /// 캘린더 데이터(public)
  List<CalendarModel>? get calendarResponse => _calendarResponse;

  final String currentUserId =
      SupabaseManager.shared.supabase.auth.currentUser?.id ?? "";

  void toggleDeleteMode() {
    deleteMode = !deleteMode;
    notifyListeners();
  }

  void cancelDeleteMode() {
    deleteMode = false;
    selectedIds.clear();
    notifyListeners();
  }

  /// 특정 카드 선택 토글
  void toggleSelected(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  /// 특정 카드가 선택됐는지 여부
  bool isSelected(String id) {
    return selectedIds.contains(id);
  }

  void setAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }

  void _init() {
    fetchCalendars();
  }

  void fetchCalendars() async {
    // 로드 시작 시 상태를 loading으로 설정
    _state = ViewState.loading;
    notifyListeners();

    try {
      _calendarResponse = await CalendarDataSource.shared
          .fetchCalendarFinalList("group");
      // 로드 성공 시 상태를 success로 설정
      _state = ViewState.success;
    } catch (e) {
      // 로드 실패 시 상태를 error로 설정
      _state = ViewState.error;
      _errorMessage = e.toString();
      // 오류 디버깅을 위해 콘솔에 출력
      debugPrint("Error loading calendars: $e");
    } finally {
      notifyListeners();
    }
  }
}
