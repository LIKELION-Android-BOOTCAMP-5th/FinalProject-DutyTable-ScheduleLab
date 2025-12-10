import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:dutytable/supabase_manager.dart';
import 'package:flutter/material.dart';

enum ViewState { loading, success, error }

class SharedCalendarViewModel extends ChangeNotifier {
  /// 데이터 로딩 상태(private)
  ViewState _state = ViewState.loading;

  /// 데이터 로딩 상태(public)
  ViewState get state => _state;

  /// 에러 메세지(private)
  String? _errorMessage;

  /// 에러 메세지(public)
  String? get errorMessage => _errorMessage;

  bool deleteMode = false;

  //TODO: 민석님 확인 해주세요
  bool isAdmin = false;

  /// 선택된 카드 id들
  final Set<String> selectedIds = {};

  /// 캘린더 데이터(private)
  List<CalendarModel>? _calendarResponse;

  /// 캘린더 데이터(public)
  List<CalendarModel>? get calendarResponse => _calendarResponse;

  final String currentUserId =
      SupabaseManager.shared.supabase.auth.currentUser?.id ?? "";

  bool _isDisposed = false;

  /// 공유 캘린더 목록 뷰모델
  SharedCalendarViewModel({List<CalendarModel>? initialCalendars}) {
    if (initialCalendars != null) {
      // splash 화면에서 받아온 데이터 있을 때
      _calendarResponse = initialCalendars;
      _state = ViewState.success;
    } else {
      // splash 화면에서 받아온 데이터 없을 때
      _state = ViewState.loading;
      fetchCalendars();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

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

  //TODO: 민석님 확인 해주세요
  void setAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }

  /// 캘린더 목록 가져오기
  void fetchCalendars() async {
    if (_isDisposed) return;

    _state = ViewState.loading;
    notifyListeners();

    try {
      _calendarResponse = await CalendarDataSource.shared
          .fetchCalendarFinalList("group");

      if (_isDisposed) return;

      _state = ViewState.success;
    } catch (e) {
      if (_isDisposed) return;

      _state = ViewState.error;
      _errorMessage = e.toString();
      debugPrint("Error loading calendars: $e");
    } finally {
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }
}
