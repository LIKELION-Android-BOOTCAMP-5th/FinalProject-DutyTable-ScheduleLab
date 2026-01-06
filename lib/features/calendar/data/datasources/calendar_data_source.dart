import 'package:dio/dio.dart'; // Dio 라이브러리 임포트
import 'package:dutytable/core/network/dio_client.dart';
import 'package:flutter/foundation.dart'; // debugPrint를 위해 추가

import '../../../../core/utils/extensions.dart';
import '../../../../main.dart';
import '../models/calendar_member_model.dart';
import '../models/calendar_model.dart';

class CalendarDataSource {
  CalendarDataSource._();
  static final CalendarDataSource instance = CalendarDataSource._();

  final Dio _dio = DioClient.shared.dio;

  /// CREATE
  /// 캘린더 추가
  Future<int> addSharedCalendar({
    required String title,
    String? imageURL,
    String? description,
    required List<String> invitedUserIds,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('로그인 필요');

    // 캘린더 생성 (id 반환)
    final response = await _dio.post(
      '/rest/v1/calendars',
      options: Options(headers: const {'Prefer': 'return=representation'}),
      data: {
        'type': 'group',
        'user_id': user.id,
        'title': title,
        'imageURL': imageURL,
        'description': description,
      },
    );

    final calendarId = response.data[0]['id'];

    // 초대 멤버 추가 (생성자는 트리거가 처리)
    if (invitedUserIds.isNotEmpty) {
      final members = invitedUserIds
          .map((uid) => {'calendar_id': calendarId, 'user_id': uid})
          .toList();

      await _dio.post('/rest/v1/invite_notifications', data: members);
    }

    return calendarId;
  }

  /// 멤버 초대
  Future<void> inviteUsers(int calendarId, List<String> invitedUserIds) async {
    if (invitedUserIds.isNotEmpty) {
      final members = invitedUserIds
          .map((uid) => {'calendar_id': calendarId, 'user_id': uid})
          .toList();

      await _dio.post('/rest/v1/invite_notifications', data: members);
    }
  }

  /// UPDATE
  /// 캘린더 수정
  Future<bool> updateCalendarInfo({
    String? title,
    String? description,
    String? imageURL,
    required int calendarId,
  }) async {
    try {
      // 1. 전송할 데이터 맵을 빈 상태로 시작
      final Map<String, dynamic> data = {};

      // 2. 전달된 값이 있을 때만(Null이 아닐 때만) 맵에 추가
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      data['imageURL'] = imageURL;

      // 3. 값이 없다면 호출 X
      if (data.isEmpty) return true;

      final response = await _dio.patch(
        '/rest/v1/calendars',
        queryParameters: {'id': 'eq.$calendarId'},
        options: Options(headers: const {'Prefer': 'return=representation'}),
        data: data,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      return false;
    }
  }

  /// 방장 이전
  Future<void> transferAdminRole(int calendarId, String newAdminId) async {
    final currentUserId = supabase.auth.currentUser!.id;

    // supabase function
    await supabase.rpc(
      'transfer_admin_role',
      params: {
        'p_calendar_id': calendarId,
        'p_new_admin_id': newAdminId,
        'p_old_admin_id': currentUserId,
      },
    );
  }

  /// READ
  /// 개인 캘린더 가져오기 (없으면 생성)
  Future<CalendarModel> fetchPersonalCalendar() async {
    final userId = supabase.auth.currentUser?.id ?? "";
    if (userId.isEmpty) throw Exception('로그인 필요');

    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': '*,calendars_user_id_fkey(nickname, profile_url)',
        'user_id': 'eq.$userId',
        'type': 'eq.personal',
        'limit': 1,
      },
    );

    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> jsonData = response.data;

      if (jsonData.isNotEmpty) {
        // 캘린더가 존재하면 바로 반환
        return CalendarModel.fromJson(jsonData.first as Map<String, dynamic>);
      } else {
        // 캘린더가 없으면 생성 후 반환
        return await _createAndFetchPersonalCalendar(userId);
      }
    } else {
      throw Exception('Failed to load calendar: Status ${response.statusCode}');
    }
  }

  /// 수파베이스에서 is_google_calendar_connection 정보 가져오기
  Future<bool> fetchIsGoogleCalendarConnection() async {
    final currentUserId = supabase.auth.currentUser?.id;
    final response = await _dio.get(
      '/rest/v1/users',
      queryParameters: {
        'select': 'is_google_calendar_connect',
        'id': 'eq.$currentUserId',
        'limit': 1,
      },
    );
    return response.data[0]['is_google_calendar_connect'] as bool;
  }

  /// 개인 캘린더를 생성하고, 생성자를 멤버로 추가한 뒤, 생성된 캘린더 정보를 반환
  Future<CalendarModel> _createAndFetchPersonalCalendar(String userId) async {
    // '내 캘린더'라는 이름으로 개인 캘린더 생성
    final calendarResponse = await _dio.post(
      '/rest/v1/calendars',
      options: Options(headers: const {'Prefer': 'return=representation'}),
      data: {
        'type': 'personal',
        'user_id': userId,
        'title': '내 캘린더', // 기본 제목
      },
    );

    final newCalendarData = calendarResponse.data[0];
    final calendarId = newCalendarData['id'];

    // 생성된 캘린더 정보를 모델로 변환하여 반환
    return CalendarModel.fromJson(newCalendarData as Map<String, dynamic>);
  }

  /// 단일 캘린더 조회
  Future<CalendarModel> fetchSharedCalendarFromId(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': '*,calendars_user_id_fkey(nickname, profile_url)',
        'id': 'eq.$calendarId',
      },
    );
    CalendarModel calendar;
    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> jsonData = response.data;

      if (jsonData.isNotEmpty) {
        calendar = CalendarModel.fromJson(
          jsonData.first as Map<String, dynamic>,
        );
      } else {
        throw Exception('Calendar not found.');
      }
    } else {
      throw Exception('Failed to load calendar: Status ${response.statusCode}');
    }

    // 3단계: 각 캘린더의 멤버 목록을 비동기적으로 가져와 병합
    final List<CalendarMemberModel> memberList = await fetchCalendarMembers(
      calendar.id,
    );

    calendar.calendarMemberModel = memberList;

    return calendar;
  }

  /// 특정 ID의 캘린더 제목 가져오기
  Future<String> getCalendarTitleById(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': 'title',
        'id': 'eq.$calendarId',
        'limit': 1,
      },
    );

    if (response.data != null && (response.data as List).isNotEmpty) {
      return (response.data as List).first['title'] as String;
    } else {
      throw Exception('Calendar not found');
    }
  }

  /// 멤버 목록 가져오기
  Future<List<CalendarMemberModel>> fetchCalendarMembers(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendar_members',
      queryParameters: {
        'select': '*,users(nickname, profile_url)',
        'calendar_id': 'eq.$calendarId',
      },
    );

    if (response.statusCode != 200 || response.data is! List) {
      throw Exception(
        'Failed to load calendar Member: Status ${response.statusCode}',
      );
    }

    final List<dynamic> jsonData = response.data;

    if (jsonData.isEmpty) return [];

    final members = jsonData
        .map(
          (jsonItem) =>
              CalendarMemberModel.fromJson(jsonItem as Map<String, dynamic>),
        )
        .toList();

    // 방장을 제일 위로 정렬
    members.sort((a, b) {
      if (a.isAdmin == b.isAdmin) return 0;
      return a.isAdmin ? -1 : 1;
    });

    return members;
  }

  /// 공유 캘린더 목록 가져오기
  Future<List<CalendarModel>> fetchCalendarFinalList(String type) async {
    final userId = supabase.auth.currentUser?.id ?? "";

    // 1단계: 현재 유저가 포함된 캘린더 ID 목록 가져오기
    Response filterResponse;
    try {
      filterResponse = await _dio.get(
        '/rest/v1/calendar_members',
        queryParameters: {
          'select': 'calendar_id,calendars(type)',
          'user_id': 'eq.$userId',
          'calendars.type': 'eq.$type',
        },
      );
    } on DioException catch (e) {
      debugPrint('1단계 DioException: ${e.message}');
      throw Exception('Failed to filter calendar IDs: ${e.message}');
    }

    if (filterResponse.statusCode != 200 || !(filterResponse.data is List)) {
      throw Exception(
        'Failed to filter calendar IDs: Status ${filterResponse.statusCode}, Body: ${filterResponse.data}',
      );
    }

    final List<dynamic> idData = filterResponse.data;
    if (idData.isEmpty) {
      return [];
    }

    final List<int> calendarIds = idData
        .map((item) => item['calendar_id'] as int?)
        .whereType<int>()
        .toList();

    if (calendarIds.isEmpty) {
      return [];
    }
    final String idsQuery = calendarIds.join(',');

    // 2단계: 필터링된 ID 목록으로 캘린더 기본 데이터 목록 가져오기
    Response calendarResponse;
    try {
      calendarResponse = await _dio.get(
        '/rest/v1/calendars',
        queryParameters: {
          'select': '*,calendars_user_id_fkey(nickname, profile_url)',
          'id': 'in.($idsQuery)',
          'type': 'eq.$type',
        },
      );
    } on DioException catch (e) {
      debugPrint('2단계 DioException: ${e.message}');
      throw Exception('Failed to load calendars: ${e.message}');
    }

    if (calendarResponse.statusCode != 200 ||
        !(calendarResponse.data is List)) {
      throw Exception(
        'Failed to load calendars: Status ${calendarResponse.statusCode}',
      );
    }

    final List<dynamic> calendarJsonData = calendarResponse.data;
    final List<CalendarModel> calendars = calendarJsonData
        .map(
          (jsonItem) =>
              CalendarModel.fromJson(jsonItem as Map<String, dynamic>),
        )
        .toList();
    // 3단계: 각 캘린더의 멤버 목록을 비동기적으로 가져와 병합
    final List<Future<List<CalendarMemberModel>?>> memberFutures = calendars
        .map((calendar) => fetchCalendarMembers(calendar.id))
        .toList();

    final List<List<CalendarMemberModel>?> allMembersLists = await Future.wait(
      memberFutures,
    );

    // 캘린더 모델에 멤버 목록 결합
    for (int i = 0; i < calendars.length; i++) {
      calendars[i].calendarMemberModel = allMembersLists[i];
    }

    return calendars;
  }

  /// 특정 캘린더의 안 읽은 채팅 개수 가져오기
  Future<int> fetchUnreadChatCount(int calendarId, String userId) async {
    // 1. 유저의 마지막 읽은 시간(last_read_at) 가져오기
    final memberResponse = await _dio.get(
      '/rest/v1/calendar_members',
      queryParameters: {
        'select': 'last_read_at',
        'calendar_id': 'eq.$calendarId',
        'user_id': 'eq.$userId',
      },
    );

    if (memberResponse.data == null || (memberResponse.data as List).isEmpty) {
      return 0;
    }

    final String? lastReadAt = memberResponse.data[0]['last_read_at'];
    if (lastReadAt == null) return 0;

    // 2. last_read_at 이후에 생성된 메시지 카운트
    final chatResponse = await _dio.get(
      '/rest/v1/chat_messages',
      queryParameters: {
        'select': 'id',
        'calendar_id': 'eq.$calendarId',
        'created_at': 'gt.$lastReadAt',
      },
      options: Options(headers: {'Prefer': 'count=exact'}),
    );

    return (chatResponse.data as List).length;
  }

  /// 다음 일정 가져오기
  Future<Map<String, dynamic>?> fetchNextSchedule(int calendarId) async {
    final String now = DateTime.now().toUtc().toIso8601String();

    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {
        'select': 'title,started_at',
        'calendar_id': 'eq.$calendarId',
        'started_at': 'gt.$now',
        'order': 'started_at.asc',
        'limit': 1,
      },
    );

    if (response.data is List && (response.data as List).isNotEmpty) {
      return response.data[0] as Map<String, dynamic>;
    }
    return null;
  }

  /// DELETE
  /// supabase storage 에 이미지 삭제
  Future<void> deleteCalendarImage(String? imageUrl) async {
    final path = extractStoragePath(imageUrl);
    if (path == null) return;

    await supabase.storage.from('calendar-images').remove([path]);
  }

  /// 다수의 캘린더 선택하여 나가기(삭제)(내가 방장이 아닌 캘린더들만)
  Future<void> outCalendars(List<int> calendarIds) async {
    final currentUser = supabase.auth.currentUser;
    await _dio.delete(
      '/rest/v1/calendar_members',
      queryParameters: {
        'calendar_id': 'in.(${calendarIds.join(",")})',
        'is_admin': 'eq.false',
        'user_id': 'eq.${currentUser!.id}',
      },
    );
  }

  /// 단일 캘린더 나가기(내가 방장이 아닌 캘린더만)
  Future<void> outCalendar(int calendarId) async {
    final currentUser = supabase.auth.currentUser;
    await _dio.delete(
      '/rest/v1/calendar_members',
      queryParameters: {
        'calendar_id': 'eq.$calendarId',
        'is_admin': 'eq.false',
        'user_id': 'eq.${currentUser!.id}',
      },
    );
  }

  /// 단일 캘린더 삭제 (방장만 가능)
  Future<void> deleteCalendar(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {'select': 'id,imageURL', 'id': 'eq.$calendarId'},
    );

    final List data = response.data as List;
    final String? imageURL = data.first['imageURL'] as String?;

    // 캘린더 삭제(멤버는 디비에서 cascade로 삭제 처리)
    await _dio.delete(
      '/rest/v1/calendars',
      queryParameters: {'id': 'eq.$calendarId'},
    );

    // 이미지 삭제
    await deleteCalendarImage(imageURL);
  }

  /// 멤버 추방
  Future<void> exileMember(int calendarId, String userId) async {
    await _dio.delete(
      '/rest/v1/calendar_members',
      queryParameters: {
        'calendar_id': 'eq.$calendarId',
        'user_id': 'eq.$userId',
      },
    );
  }
}
