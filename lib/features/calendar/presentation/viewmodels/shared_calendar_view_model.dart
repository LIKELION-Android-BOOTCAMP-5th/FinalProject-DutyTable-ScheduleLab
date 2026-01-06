import 'package:dutytable/core/services/supabase_manager.dart';
import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../features/notification/data/datasources/notification_data_source.dart';
import '../../../../main.dart';
import '../../data/datasources/user_data_source.dart';

enum ViewState { loading, success, error }

class SharedCalendarViewModel extends ChangeNotifier {
  final Map<String, String> _invitedUsers = {};

  String? _inviteError;

  Map<String, String> get invitedUsers => _invitedUsers;

  String? get inviteError => _inviteError;

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

  /// 마지막으로 처리한 새로고침 신호
  String? _lastProcessedSignalId;

  Future<void> fetchCalendarsWithSignal(Map<String, dynamic>? extra) async {
    if (extra == null || extra['refresh'] != true) return;

    // 신호에 포함된 고유 ID를 확인
    final String? signalId = extra['signalId'];

    // 이미 처리한 ID라면 다시 실행하지 않음
    if (signalId != null && _lastProcessedSignalId == signalId) {
      return;
    }

    // 처리 시작
    _lastProcessedSignalId = signalId;

    // 실제 서버 데이터 로드 로직
    await fetchCalendars();
  }

  /// 공유 캘린더 목록 뷰모델
  SharedCalendarViewModel({
    List<CalendarModel>? calendarList,
    CalendarModel? calendar,
  }) {
    if (calendar != null) {
      // 5단계 : 데이터 받아서 입력
      _calendar = calendar;
    }
    fetchCalendars();
  }

  Future<void> addInvitedUserByNickname(String nickname) async {
    final value = nickname.trim();
    if (value.isEmpty) {
      _inviteError = '닉네임을 입력해주세요';
      notifyListeners();
      return;
    }

    try {
      final user = await UserDataSource.shared.findUserByNickname(value);
      final memberIds =
          _calendar!.calendarMemberModel?.map((e) {
            return e.userId;
          }).toList() ??
          [];
      if (user == null) {
        _inviteError = '존재하지 않는 사용자입니다.';
      } else if (_invitedUsers.containsKey(user['id'])) {
        _inviteError = '이미 추가된 사용자입니다.';
      } else if (user['id'] == currentUserId) {
        _inviteError = '자신은 추가 할 수 없습니다.';
      } else if (memberIds.contains(user['id'])) {
        _inviteError = '이미 멤버인 사용자 입니다.';
      } else {
        // 초대 보류중인지 확인
        final hasPending = await NotificationDataSource.shared
            .hasPendingInvite(_calendar!.id, user['id']!);
        if (hasPending) {
          _inviteError = '이미 초대된 닉네임 입니다.';
        } else {
          _invitedUsers[user['id']!] = user['nickname']!;
          _inviteError = null;
        }
      }
    } catch (e) {
      _inviteError = '사용자 확인 중 오류가 발생했습니다.';
    }
    notifyListeners();
  }

  void removeInvitedUser(String userId) {
    _invitedUsers.remove(userId);
    notifyListeners();
  }

  void onConfirm() async {
    if (_invitedUsers.isEmpty) return;

    try {
      await CalendarDataSource.instance.inviteUsers(
        _calendar!.id,
        _invitedUsers.keys.toList(),
      );
    } catch (e) {
      print("에러 : $e");
    } finally {
      _invitedUsers.clear();
      notifyListeners();
    }
  }

  void clearError() {
    _inviteError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (var channel in _channels) {
      channel.unsubscribe();
    }
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

  /// 캘린더 목록 가져오기
  Future<void> fetchCalendars() async {
    if (_isDisposed) return;

    _state = ViewState.loading;
    notifyListeners();

    try {
      // 1. 기본 목록 가져오기
      final calendars = await CalendarDataSource.instance
          .fetchCalendarFinalList("group");
      _calendarList = calendars;

      if (_isDisposed) return;

      if (_calendarList != null && _calendarList!.isNotEmpty) {
        // 2. 모든 추가 데이터를 병렬로 가져옴
        await Future.wait(
          _calendarList!.map((calendar) async {
            await loadUnreadCount(calendar.id, shouldNotify: false);
            await nextSchedule(calendar.id, shouldNotify: false);
          }),
        );
      }

      if (_isDisposed) return;

      // 3. 모든 데이터(Map 포함)가 완벽히 준비된 후 상태 변경
      _state = ViewState.success;
    } catch (e) {
      if (_isDisposed) return;
      _state = ViewState.error;
      _errorMessage = e.toString();
    } finally {
      if (!_isDisposed) {
        // 4. 실시간 구독 시작 및 최종 UI 업데이트 알림
        _subscribeToNewMessages();
        notifyListeners();
      }
    }
  }

  /// 공유 캘린더 정보 가져오기
  Future<void> fetchCalendar() async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      _calendar = await CalendarDataSource.instance.fetchSharedCalendarFromId(
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

  Future<void> outSelectedCalendars() async {
    final ids = selectedIds.map(int.parse).toList();

    if (ids.isEmpty) return;

    _state = ViewState.loading;
    notifyListeners();

    try {
      await CalendarDataSource.instance.outCalendars(ids);
      await fetchCalendars();
      cancelDeleteMode();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Map<int, int> unreadCount = {};

  // 채팅 개수 가져오기
  Future<int> chatCount(int calendarId) async {
    final List lastReadData = await supabase
        .from('calendar_members')
        .select('last_read_at')
        .eq('user_id', currentUserId)
        .eq('calendar_id', calendarId)
        .limit(1);

    if (lastReadData.isEmpty) {
      return 0;
    }

    final DateTime lastReadAt = DateTime.parse(
      lastReadData[0]['last_read_at'],
    ).toUtc();

    final List data = await supabase
        .from('chat_messages')
        .select('id')
        .eq('calendar_id', calendarId)
        .gt('created_at', lastReadAt.toIso8601String());

    return data.length;
  }

  // 안읽은 채팅 개수 로드
  Future<void> loadUnreadCount(
    int calendarId, {
    bool shouldNotify = true,
  }) async {
    try {
      final int count = await CalendarDataSource.instance.fetchUnreadChatCount(
        calendarId,
        currentUserId,
      );
      unreadCount[calendarId] = count;
      if (shouldNotify) notifyListeners();
    } catch (e) {
      debugPrint('Error loading unread count: $e');
    }
  }

  List<RealtimeChannel> _channels = [];

  // 리얼타임구독
  void _subscribeToNewMessages() {
    if (_calendarList == null) return;

    for (var calendar in _calendarList!) {
      // 새 채팅
      final chatChannel = supabase
          .channel('unread_count_${calendar.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'chat_messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'calendar_id',
              value: calendar.id,
            ),
            callback: (payload) {
              loadUnreadCount(calendar.id, shouldNotify: true);
            },
          )
          .subscribe();

      // 채팅 읽은 후
      final memberChannel = supabase
          .channel('member_update_${calendar.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'calendar_members',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'calendar_id',
              value: calendar.id,
            ),
            callback: (payload) {
              loadUnreadCount(calendar.id);
            },
          )
          .subscribe();

      _channels.add(chatChannel);
      _channels.add(memberChannel);
    }
  }

  Map<int, String?> nextScheduleTitle = {};
  Map<int, String?> nextScheduleDateMonth = {};
  Map<int, String?> nextScheduleDateDay = {};

  // 다음 일정 로드
  Future<void> nextSchedule(
    int? calendarId, {
    bool shouldNotify = false,
  }) async {
    if (calendarId == null) return;

    try {
      final data = await CalendarDataSource.instance.fetchNextSchedule(
        calendarId,
      );

      if (data != null) {
        final DateTime date = DateTime.parse(data['started_at']).toLocal();
        nextScheduleTitle[calendarId] = data['title'];
        nextScheduleDateMonth[calendarId] = date.month.toString();
        nextScheduleDateDay[calendarId] = date.day.toString();
      } else {
        nextScheduleTitle[calendarId] = "";
        nextScheduleDateMonth[calendarId] = "";
        nextScheduleDateDay[calendarId] = "";
      }

      if (shouldNotify) notifyListeners();
    } catch (e) {
      debugPrint('Error loading next schedule: $e');
    }
  }
}
