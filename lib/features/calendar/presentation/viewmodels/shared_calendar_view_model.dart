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

  /// 개인 캘린더 탭 이름 리스트(private)
  final List<String> _tabNames = ["캘린더", "리스트", "채팅"];

  /// 개인 캘린더 탭 이름 리스트(public)
  List<String> get tabNames => _tabNames;

  /// 탭 갯수(public) = 탭 이름 리스트 길이
  int get tabLength => _tabNames.length;

  /// 현재 선택 된 탭의 인덱스(private)
  int _currentIndex = 0;

  /// 현재 선택 된 탭의 인덱스(public)
  int get currentIndex => _currentIndex;

  /// 에러 메세지(private)
  String? _errorMessage;

  /// 에러 메세지(public)
  String? get errorMessage => _errorMessage;

  bool deleteMode = false;

  //TODO: 민석님 확인 해주세요
  bool isAdmin = false;

  /// 선택된 카드 id들
  final Set<String> selectedIds = {};

  /// 공유 캘린더 데이터 목록(private)
  List<CalendarModel>? _calendarList;

  /// 공유 캘린더 데이터 목록(public)
  List<CalendarModel>? get calendarList => _calendarList;

  CalendarModel? _calendar;
  CalendarModel? get calendar => _calendar;

  final String currentUserId =
      SupabaseManager.shared.supabase.auth.currentUser?.id ?? "";

  bool _isDisposed = false;

  /// 공유 캘린더 목록 뷰모델
  SharedCalendarViewModel({
    List<CalendarModel>? calendarList,
    CalendarModel? calendar,
  }) {
    if (calendar != null) {
      // 5단계 : 데이터 받아서 입력
      _calendar = calendar;
    }
    if (calendarList != null) {
      // splash 화면에서 받아온 데이터 있을 때
      _calendarList = calendarList;
      _state = ViewState.success;
    } else {
      // splash 화면에서 받아온 데이터 없을 때
      _state = ViewState.loading;
      fetchCalendars();
    }
  }

  void setInitialData(List<CalendarModel>? initialData) {
    if (initialData != null && _calendarList == null) {
      _calendarList = initialData;
      _state = ViewState.success;
      // build 단계에서 호출될 수 있으므로 마이크로태스크나 다음 프레임에 알림
      Future.microtask(() => notifyListeners());
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

  /// 카드 삭제 모드 취소
  void cancelDeleteMode() {
    deleteMode = false;
    selectedIds.clear();
    notifyListeners();
  }

  /// 특정 카드가 선택됐는지 여부
  bool isSelected(String id) {
    return selectedIds.contains(id);
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

  //TODO: 민석님 확인 해주세요
  void setAdmin(bool value) {
    isAdmin = value;
    notifyListeners();
  }

  /// 캘린더 목록 가져오기
  Future<void> fetchCalendars() async {
    if (_isDisposed) return;

    _state = ViewState.loading;
    notifyListeners();

    try {
      _calendarList = await CalendarDataSource.instance.fetchCalendarFinalList(
        "group",
      );

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

  /// 공유 캘린더 정보 가져오기
  Future<void> fetchCalendar() async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      _calendar = await CalendarDataSource.instance.fetchCalendarFromId(
        _calendar!.id,
      );
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
      debugPrint("Error loading calendars: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteSelectedCalendars() async {
    final ids = selectedIds.map(int.parse).toList();

    if (ids.isEmpty) return;

    _state = ViewState.loading;
    notifyListeners();

    try {
      await CalendarDataSource.instance.deleteCalendars(ids);
      await fetchCalendars();
      cancelDeleteMode();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
