import 'package:dio/dio.dart'; // Dio 라이브러리 임포트
import 'package:dutytable/core/network/dio_client.dart';
import 'package:flutter/foundation.dart'; // debugPrint를 위해 추가

import '../../../../extensions.dart';
import '../../../../main.dart';
import '../models/calendar_member_model.dart';
import '../models/calendar_model.dart';

class CalendarDataSource {
  CalendarDataSource._();
  static final CalendarDataSource instance = CalendarDataSource._();

  final Dio _dio = DioClient.shared.dio;

  /// CREATE
  /// 캘린더 추가
  Future<void> addSharedCalendar({
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
          .map(
            (uid) => {
              'calendar_id': calendarId,
              'user_id': uid,
              'is_admin': false,
            },
          )
          .toList();

      await _dio.post('/rest/v1/calendar_members', data: members);
    }
  }

  /// UPDATE
  /// 캘린더 수정
  /// 캘린더 수정
  Future<bool> updateCalendarInfo(
    String title,
    String description,
    int calendarId,
  ) async {
    try {
      final Map<String, dynamic> data = {
        'title': title,
        'description': description,
      };

      final response = await _dio.patch(
        '/rest/v1/calendars?id=eq.$calendarId',
        options: Options(headers: const {'Prefer': 'return=representation'}),
        data: data,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      return false;
    }
  }

  /// READ
  /// 개인 캘린더 가져오기
  Future<CalendarModel> fetchPersonalCalendar() async {
    final userId = supabase.auth.currentUser?.id ?? "";

    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': '*,calendars_user_id_fkey(nickname)',
        'user_id': 'eq.$userId',
        'type': 'eq.personal',
        'limit': 1,
      },
    );

    if (response.statusCode == 200 && response.data is List) {
      final List<dynamic> jsonData = response.data;

      if (jsonData.isNotEmpty) {
        return CalendarModel.fromJson(jsonData.first as Map<String, dynamic>);
      } else {
        throw Exception('Calendar not found for user.');
      }
    } else {
      throw Exception('Failed to load calendar: Status ${response.statusCode}');
    }
  }

  /// 단일 캘린더 조회
  Future<CalendarModel> fetchCalendarFromId(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': '*,calendars_user_id_fkey(nickname)',
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

  /// 멤버 목록 가져오기
  Future<List<CalendarMemberModel>> fetchCalendarMembers(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/calendar_members',
      queryParameters: {
        'select': '*,users(nickname)',
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
      if (a.is_admin == b.is_admin) return 0;
      return a.is_admin ? -1 : 1;
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
          'select': '*,calendars_user_id_fkey(nickname)',
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

  /// DELETE
  /// supabase storage 에 이미지 삭제
  Future<void> deleteCalendarImage(String? imageUrl) async {
    final path = extractStoragePath(imageUrl);
    if (path == null) return;

    await supabase.storage.from('calendar-images').remove([path]);
  }

  /// 캘린더 삭제 (방장만 가능)
  Future<void> deleteCalendars(List<int> calendarIds) async {
    final response = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': 'id,imageURL',
        'id': 'in.(${calendarIds.join(",")})',
      },
    );

    final List data = response.data as List;

    for (final item in data) {
      await deleteCalendarImage(item['imageURL'] as String?);
    }

    await _dio.delete(
      '/rest/v1/calendars',
      queryParameters: {'id': 'in.(${calendarIds.join(",")})'},
    );
  }
}
