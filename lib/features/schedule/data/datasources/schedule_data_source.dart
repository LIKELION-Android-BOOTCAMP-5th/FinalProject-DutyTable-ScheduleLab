import 'package:dio/dio.dart';
import 'package:dutytable/core/network/dio_client.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;

import '../models/schedule_model.dart';

class ScheduleDataSource {
  ScheduleDataSource._();
  static final ScheduleDataSource instance = ScheduleDataSource._();

  final Dio _dio = DioClient.shared.dio;

  /// google calendar API 공휴일
  Future<List<DateTime>> fetchHolidays({required int targetYear}) async {
    const String googleApiKey = "AIzaSyChi09zyRm-cUUvRYsggxCUE6hxkzRf9is";
    const String calendarId =
        "ko.south_korea#holiday@group.v.calendar.google.com";

    final Uri uri = Uri.https(
      "www.googleapis.com",
      "/calendar/v3/calendars/$calendarId/events",
      {
        'key': googleApiKey,
        'timeMin': "$targetYear-01-01T00:00:00Z",
        'timeMax': "${targetYear + 1}-12-31T23:59:59Z",
        'singleEvents': 'true',
      },
    );

    try {
      final response = await Dio().getUri(uri);

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];

        final List<DateTime> holidays = items.map((item) {
          return DateTime.parse(item['start']['date']);
        }).toList();

        holidays.sort();
        return holidays;
      }
      return [];
    } on DioException catch (e) {
      debugPrint("❌ 구글 API 상세 에러: ${e.response?.data}");
      return [];
    } catch (e) {
      debugPrint("❌ 일반 에러: $e");
      return [];
    }
  }

  /// CREATE
  Future<void> addSchedule(List<Map<String, dynamic>> payloads) async {
    try {
      await _dio.post(
        '/rest/v1/schedules',
        data: payloads,
        options: Options(headers: {'Prefer': 'return=minimal'}),
      );
    } catch (e) {
      throw Exception("create 에러:  $e");
    }
  }

  /// READ
  /// 스케줄 단건 조회
  Future<ScheduleModel> fetchScheduleById(int scheduleId) async {
    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {'select': '*', 'id': 'eq.$scheduleId'},
    );

    if (response.statusCode == 200 &&
        response.data is List &&
        response.data.isNotEmpty) {
      return ScheduleModel.fromJson(response.data.first);
    } else {
      throw Exception('Failed to load schedule detail');
    }
  }

  /// 모든 일정 불러오기
  Future<List<ScheduleModel>> fetchJoinedSharedSchedules() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) return [];

      // 1. 내가 멤버로 등록된 캘린더 ID들을 가져옴
      final memberResponse = await _dio.get(
        '/rest/v1/calendar_members',
        queryParameters: {
          'select': 'calendar_id',
          'user_id': 'eq.$currentUserId',
        },
      );

      final List<dynamic> memberData = memberResponse.data;
      if (memberData.isEmpty) return [];

      final List<int> calendarIds = memberData
          .map((item) => item['calendar_id'] as int)
          .toList();

      // 2. 해당 ID들에 속한 모든 일정 로드
      final idsQuery = "(${calendarIds.join(',')})";
      final scheduleResponse = await _dio.get(
        '/rest/v1/schedules',
        queryParameters: {'select': '*', 'calendar_id': 'in.$idsQuery'},
      );

      if (scheduleResponse.statusCode == 200) {
        final List<dynamic> jsonList = scheduleResponse.data;
        return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ fetchJoinedSharedSchedules 에러: $e");
      return [];
    }
  }

  Future<List<ScheduleModel>> fetchSchedulesByRange({
    required int calendarId,
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {
        'select': '*',
        'calendar_id': 'eq.$calendarId',
        // 1. 시작일이 종료 범위(to)보다 작거나 같고 (검색 범위 끝보다 먼저 시작)
        // 2. 종료일이 시작 범위(from)보다 크거나 같아야 함 (검색 범위 시작보다 나중에 끝남)
        'started_at': 'lte.${to.toIso8601String()}',
        'ended_at': 'gte.${from.toIso8601String()}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load schedules by range");
    }
  }

  /// 스케줄 조회
  Future<List<ScheduleModel>> fetchSchedules(int calendarId) async {
    final response = await _dio.get(
      '/rest/v1/schedules',
      queryParameters: {'select': '*', 'calendar_id': 'eq.$calendarId'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load schedules");
    }
  }

  /// 내 일정 불러오기
  Future<List<ScheduleModel>> fetchMySchedules({
    DateTime? from,
    DateTime? to,
  }) async {
    final currentUserId = supabase.auth.currentUser?.id;
    final data = await _dio.get(
      '/rest/v1/calendars',
      queryParameters: {
        'select': 'id',
        'user_id': 'eq.$currentUserId',
        'type': 'eq.personal',
      },
    );

    final List<dynamic> jsonData = data.data;
    if (jsonData.isEmpty) return [];

    final myCalendarId = jsonData.first['id'];

    // 기간 파라미터가 있으면 범위 쿼리, 없으면 전체 쿼리 실행(위젯을 위해 확장성 있게 변경함)
    if (from != null && to != null) {
      return fetchSchedulesByRange(
        calendarId: myCalendarId,
        from: from,
        to: to,
      );
    } else {
      return fetchSchedules(myCalendarId);
    }
  }

  /// 로그인 정보 받기
  void setGoogleAccount(GoogleSignInAccount? account) {
    _connectedAccount = account;
  }

  /// 일정 가져와서 리스트에 넣기
  GoogleSignInAccount? _connectedAccount;
  Future<List<Map<String, dynamic>>> syncGoogleCalendarToSchedule() async {
    try {
      //TODO: 추후 개선의 여지가 있어보여 남겨놓습니다.
      // const List<String> scopes = <String>[
      //   'https://www.googleapis.com/auth/contacts.readonly',
      // ];
      // final GoogleSignInAccount? user =
      // final GoogleSignInClientAuthorization? authorization = await user
      //     ?.authorizationClient
      //     .authorizationForScopes(scopes);
      final googleSignIn = await GoogleSignIn.instance.authorizationClient;
      // fianl GoogleSignInAccount acc = GoogleSignInAccount.
      // if (googleSignIn == null) {
      //   Fluttertoast.showToast(msg: "구글 로그인 정보가 없습니다.");
      //   return [];
      // }

      final authorization = await googleSignIn.authorizationForScopes([
        'https://www.googleapis.com/auth/calendar',
      ]);
      final client = _GoogleAuthClient(authorization!.accessToken);

      final calendarApi = calendar.CalendarApi(client);

      final events = await calendarApi.events.list("primary");
      if (events.items == null || events.items!.isEmpty) {
        Fluttertoast.showToast(msg: "가져올 일정이 없습니다.");
        return [];
      }
      List<Map<String, dynamic>> googleSyncSchedule = [];

      for (var event in events.items!) {
        googleSyncSchedule.add({
          'title': "[구글] ${event.summary ?? '(제목 없음)'}",
          'memo': event.description,
          'started_at': event.start?.dateTime?.toIso8601String(),
          'ended_at': event.end?.dateTime?.toIso8601String(),
          'location': event.location,
          'color_value': '0xFF4285F4',
        });
      }

      return googleSyncSchedule;
    } catch (e) {
      Fluttertoast.showToast(msg: "일정 가져오기에 실패했습니다.");
      return [];
    }
  }

  /// UPDATE
  /// 스케줄 수정
  Future<void> updateSchedule({
    required int scheduleId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      await _dio.patch(
        '/rest/v1/schedules',
        queryParameters: {'id': 'eq.$scheduleId'},
        data: payload,
      );
    } catch (e) {
      throw Exception("단건 수정 에러: $e");
    }
  }

  /// 반복 그룹 일괄 수정
  Future<void> updateSchedulesByGroupId({
    required String repeatGroupId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _dio.patch(
        '/rest/v1/schedules',
        queryParameters: {'repeat_group_id': 'eq.$repeatGroupId'},
        data: payload,
        options: Options(
          headers: {
            // 수정된 데이터를 결과로 받겠다고 명시
            'Prefer': 'return=representation',
          },
        ),
      );

      // 로그 확인: 수정된 데이터 리스트가 비어있다면 필터(id)가 잘못된 것입니다.
    } catch (e) {
      throw Exception("그룹 일괄 수정 에러: $e");
    }
  }

  /// DELETE
  /// 스케줄 삭제
  Future<void> deleteSchedules(int scheduleId) async {
    final response = await _dio.delete(
      '/rest/v1/schedules',
      queryParameters: {'id': 'eq.$scheduleId'},
    );

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception("Failed to load schedules");
    }
  }

  Future<void> deleteSchedulesByGroupId(String groupId) async {
    try {
      await _dio.delete(
        '/rest/v1/schedules',
        queryParameters: {'repeat_group_id': 'eq.$groupId'},
      );
    } catch (e) {
      throw Exception("그룹 일괄 삭제 에러: $e");
    }
  }

  Future<void> deleteAllSchedules(Set<String> scheduleIds) async {
    if (scheduleIds.isEmpty) return;

    final ids = scheduleIds.join(',');

    final response = await _dio.delete(
      '/rest/v1/schedules',
      queryParameters: {'id': 'in.($ids)'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete schedules');
    }
  }
}

// HTTP 클라이언트 (ProfileViewmodel 클래스 밖에 추가)
class _GoogleAuthClient extends http.BaseClient {
  final String _token;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _client.send(request);
  }
}
