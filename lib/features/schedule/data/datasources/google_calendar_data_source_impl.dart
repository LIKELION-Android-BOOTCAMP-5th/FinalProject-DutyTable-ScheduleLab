import 'package:dio/dio.dart';
import 'package:dutytable/features/schedule/data/datasources/google_calendar_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;

@LazySingleton(as: GoogleCalendarDataSource)
class GoogleCalendarDataSourceImpl implements GoogleCalendarDataSource {
  final Dio _dio;

  GoogleSignInAccount? _connectedAccount;

  GoogleCalendarDataSourceImpl(this._dio);

  // ------------------ Google Holiday ------------------
  @override
  Future<List<DateTime>> fetchHolidays(int targetYear) async {
    const calendarId = "ko.south_korea#holiday@group.v.calendar.google.com";

    final uri = Uri.https(
      "www.googleapis.com",
      "/calendar/v3/calendars/$calendarId/events",
      {
        'key': const String.fromEnvironment('GOOGLE_API_KEY'),
        'timeMin': "$targetYear-01-01T00:00:00Z",
        'timeMax': "${targetYear + 1}-12-31T23:59:59Z",
        'singleEvents': 'true',
      },
    );

    final response = await _dio.getUri(uri);
    final List items = response.data['items'] ?? [];

    return items
        .map<DateTime>((e) => DateTime.parse(e['start']['date']))
        .toList()
      ..sort();
  }

  // ------------------ Google Sync ------------------
  @override
  void setGoogleAccount(GoogleSignInAccount? account) {
    _connectedAccount = account;
  }

  @override
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
      final googleSignIn = GoogleSignIn.instance.authorizationClient;
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
}

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
