import 'package:dio/dio.dart'; // Dio 라이브러리 임포트
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../main.dart';
import '../models/calendar_member_model.dart';
import '../models/calendar_model.dart';

@lazySingleton
class CalendarDataSource {
  CalendarDataSource(this._dio);
  final Dio _dio;

  /// CREATE
  /// 캘린더 추가
  Future<int> createSharedCalendar({
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
    } on DioException {
      return false;
    }
  }

  /// READ
  /// 개인 캘린더 가져오기 (없으면 생성)
  Future<CalendarModel> readPersonalCalendar() async {
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
  Future<CalendarModel> readSharedCalendarFromId(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': '*,calendars_user_id_fkey(nickname, profile_url)',
        'id': 'eq.$calendarId',
      },
    );

    if (response.statusCode != 200 || (response.data as List).isEmpty) {
      throw Exception('Calendar not found.');
    }

    final json = response.data.first as Map<String, dynamic>;

    // 1. 멤버 리스트를 먼저 가져옵니다.
    final List<CalendarMemberModel> memberList = await readCalendarMembers(
      calendarId,
    );

    // 2. 'final' 에러를 피하기 위해, 객체 생성 시점에 멤버 리스트를 넣어줍니다.
    // 이제 여기서 'members: memberList'를 인식할 수 있습니다.
    return CalendarModel.fromJson(json, members: memberList);
  }

  /// 특정 ID의 캘린더 제목 가져오기
  Future<String> readCalendarTitleById(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {'select': 'title', 'id': 'eq.$calendarId', 'limit': 1},
    );

    if (response.data != null && (response.data as List).isNotEmpty) {
      return (response.data as List).first['title'] as String;
    } else {
      throw Exception('Calendar not found');
    }
  }

  /// 멤버 목록 가져오기
  Future<List<CalendarMemberModel>> readCalendarMembers(int calendarId) async {
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
  Future<List<CalendarModel>> readCalendarFinalList(String type) async {
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

    if (filterResponse.statusCode != 200 || filterResponse.data is! List) {
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

    // 2단계: 캘린더 기본 데이터(Raw JSON) 가져오기
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': '*,calendars_user_id_fkey(nickname, profile_url)',
        'id': 'in.($idsQuery)',
        'type': 'eq.$type',
      },
    );

    final List<dynamic> calendarJsonData = response.data;

    final List<List<CalendarMemberModel>> allMembersLists = await Future.wait(
      calendarJsonData.map((json) => readCalendarMembers(json['id'] as int)),
    );

    final List<CalendarModel> calendars = [];

    for (int i = 0; i < calendarJsonData.length; i++) {
      final Map<String, dynamic> json = calendarJsonData[i];
      final List<CalendarMemberModel> members = allMembersLists[i];

      calendars.add(CalendarModel.fromJson(json, members: members));
    }

    return calendars;
  }

  /// 특정 캘린더의 안 읽은 채팅 개수 가져오기
  Future<int> readUnreadChatCount(int calendarId, String userId) async {
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
  Future<Map<String, dynamic>?> readNextSchedule(int calendarId) async {
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
}
