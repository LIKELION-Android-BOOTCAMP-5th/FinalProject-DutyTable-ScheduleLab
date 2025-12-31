import 'dart:async';
import 'dart:io';

import 'package:dutytable/core/services/supabase_storage_service.dart';
import 'package:dutytable/features/profile/data/datasources/profile_data_source.dart';
import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/device_resource_service.dart';

class ProfileViewmodel extends ChangeNotifier {
  ProfileViewmodel() {
    _init();
  }

  /// 현재 로그인 유저
  final user = supabase.auth.currentUser;

  /// 닉네임 수정
  final nicknameController = TextEditingController();

  final DeviceResourceService _resourceService = DeviceResourceService();

  /// 이메일
  String email = "";

  /// 프로필 url
  String? image = "";

  /// 닉네임
  String nickname = "닉네임";

  /// 수정버튼
  bool is_edit = false;

  ///캘린더 동기화 버튼
  bool is_sync = false;

  /// 알림 활성화
  bool is_active_notification = true;

  /// 닉네임 중복 여부
  bool is_overlapping = true;

  /// 온보딩 다시보기
  bool _isShowOnboarding = false;
  bool get isShowOnboarding => _isShowOnboarding;

  /// 이미지 업로드
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 시작할때 닉네임,이메일,프로필 이미지 호출
  void _init() {
    fetchUser();
    nicknameCancel();
  }

  //프로필 수정
  void setProfileEdit() {
    is_edit = !is_edit;
    is_overlapping = true;
    notifyListeners();
  }

  // 닉네임 텍스트 수정
  void editNickname() {
    this.nickname = nicknameController.text.trim();
    notifyListeners();
  }

  //알림 토글
  void activeNotification() {
    is_active_notification = !is_active_notification;
    notifyListeners();
  }

  // 온보딩 토글
  void toggleOnboarding() {
    _isShowOnboarding = !isShowOnboarding;
    notifyListeners();
  }

  //닉네임 수정한거 수파베이스에 반영하기
  Future<void> updateNickname(String userId) async {
    await ProfileDataSource.instance.updateUserProfile(
      userId: userId,
      payload: {'nickname': nicknameController.text.trim()},
    );
    nickname = nicknameController.text.trim();
    notifyListeners();
  }

  // 닉네임,이메일, 프로필 사진 불러오기
  Future<void> fetchUser() async {
    final data = await ProfileDataSource.instance.fetchUserProfile();
    nickname = data!['nickname'];
    nicknameController.text = nickname;
    email = data['email'];
    image = (data['profileurl'] ?? "");
    is_sync = data['is_google_calendar_connect'] ?? false;
    notifyListeners();
  }

  // 구글 연동하기
  Future<void> updateGoogleSync(String userId, bool syncStatus) async {
    await ProfileDataSource.instance.updateUserProfile(
      userId: userId,
      payload: {'is_google_calendar_connect': syncStatus},
    );
    is_sync = syncStatus;
    notifyListeners();
  }

  //알림 on/off하기
  Future<void> updateNotification(String userId) async {
    await ProfileDataSource.instance.updateUserProfile(
      userId: userId,
      payload: {'allowed_notification': is_active_notification},
    );
    is_active_notification = is_active_notification;
    notifyListeners();
  }

  // 이미지 피커로 갤러리에서 사진 가져오기
  File? _image;
  final ImagePicker picker = ImagePicker();

  /// 이미지 선택
  Future<void> pickProfileImage(ImageSource source) async {
    final File? pickedFile = await _resourceService.pickImage(source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    notifyListeners();
  }

  /// 이미지 삭제
  Future<void> deleteImage() async {
    _image = null;
    notifyListeners();
  }

  Future<void> upload() async {
    if (_image == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final fileToUpload = File(_image!.path);

      final publicUrl = await SupabaseStorageService().uploadProfileImage(
        fileToUpload,
      );

      if (publicUrl != null) {
        await updateImage(user!.id, publicUrl);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('업로드 및 업데이트 실패: $e');
    }
  }

  // 수파베이스에 저장
  Future<void> updateImage(String userId, String? publicUrl) async {
    await ProfileDataSource.instance.updateUserProfile(
      userId: userId,
      payload: {'profileurl': publicUrl},
    );
    image = publicUrl;
    notifyListeners();
  }

  //   닉네임 조건 체크
  void nicknameCheck() {
    if (nicknameController.text.length > 1 &&
        nicknameController.text.length < 11 &&
        is_overlapping == false) {
      setProfileEdit();
    } else if (is_overlapping == true) {
    } else {}
    notifyListeners();
  }

  //  닉네임 중복
  Future<void> nicknameOverlapping() async {
    final editingNickname = nicknameController.text;
    final count = await ProfileDataSource.instance.isDuplicateNickname(
      editingNickname,
    );
    if (count == false) {
      // 중복임
      is_overlapping = true;
      Fluttertoast.showToast(msg: "중복된 닉네임입니다.");
    } else if (nicknameController.text.length < 2 ||
        nicknameController.text.length > 10) {
      Fluttertoast.showToast(msg: "닉네임은 2~10글자로 입력해야 합니다.");
    } else {
      is_overlapping = false;
      Fluttertoast.showToast(msg: "사용가능한 닉네임입니다.");
    }
  }

  //로그아웃 하기
  Future<void> logout() async {
    await supabase.auth.signOut();
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }

  // 회원탈퇴
  Future<void> deleteUser() async {
    await ProfileDataSource.instance.deleteUser(user!.id);
  }

  // 버튼 텍스트
  String nicknameButtonText() {
    final result;
    (is_edit == false)
        ? result = "수정"
        : (nickname == nicknameController.text)
        ? result = "취소"
        : result = "저장";
    return result;
  }

  //버튼 기능
  void nicknameButtonFunc() {
    if (is_edit == false) {
      // 수정
      setProfileEdit();
    } else if (is_edit == true && nickname == nicknameController.text) {
      // 취소
      nicknameController.text = nickname;
      is_edit = false;
    } else {
      if (nicknameController.text.length > 1 &&
          nicknameController.text.length < 11 &&
          is_overlapping == false) {
        // 저장
        updateNickname(user!.id);
        editNickname();
        setProfileEdit();
      } else if (is_overlapping == true) {
        //중복체크 안했을때
        Fluttertoast.showToast(msg: "중복체크를 해주세요.");
      } else {}
    }
    notifyListeners();
  }

  // 닉네임 변경되면 저장, 변경안되면 취소버튼
  void nicknameCancel() {
    nicknameController.addListener(() {
      notifyListeners();
    });
  }

  // 동기화 연결,연결해제
  Future<void> googleSync() async {
    if (!is_sync) {
      // 연결하기
      try {
        final googleSignIn = GoogleSignIn.instance;

        await googleSignIn.initialize(
          serverClientId:
              '174693600398-vng406q0u208sbnonb5hc3va8u9384u9.apps.googleusercontent.com',
        );

        final account = await googleSignIn.authenticate();

        if (account == null) {
          Fluttertoast.showToast(msg: "구글 로그인이 취소되었습니다.");
          return;
        }

        await account.authorizationClient.authorizeScopes([
          'https://www.googleapis.com/auth/calendar',
        ]);

        _connectedAccount = account; // 저장 추가

        await updateGoogleSync(user!.id, true);
        is_sync = true;
        notifyListeners();

        Fluttertoast.showToast(msg: "구글 캘린더 연동이 완료되었습니다.");

        // 일정 동기화 호출
        await syncGoogleCalendarToSchedule();
      } catch (e) {
        print('연동 오류: $e');
        Fluttertoast.showToast(msg: "구글 캘린더 연동에 실패했습니다.");
      }
    } else {
      // 연결 해제하기
      try {
        final googleSignIn = GoogleSignIn.instance;
        await googleSignIn.signOut();

        _connectedAccount = null; // 초기화 추가
        await _deleteGoogleCalendarEvents();
        await updateGoogleSync(user!.id, false);
        is_sync = false;
        notifyListeners();

        Fluttertoast.showToast(msg: "구글 캘린더 연동이 해제되었습니다.");
      } catch (e) {
        print('연동 해제 오류: $e');
        Fluttertoast.showToast(msg: "연동 해제에 실패했습니다.");
      }
    }
  }

  GoogleSignInAccount? _connectedAccount;

  // 구글 캘린더 일정을 스케줄 테이블에 추가
  Future<void> syncGoogleCalendarToSchedule() async {
    try {
      if (_connectedAccount == null) {
        Fluttertoast.showToast(msg: "구글 로그인 정보가 없습니다.");
        return;
      }

      final account = _connectedAccount!;

      // 2. API 클라이언트 생성
      final authorization = await account.authorizationClient
          .authorizationForScopes(['https://www.googleapis.com/auth/calendar']);
      final client = _GoogleAuthClient(authorization!.accessToken);

      final calendarApi = calendar.CalendarApi(client);

      // 3. 구글 캘린더 이벤트 가져오기
      final events = await calendarApi.events.list("primary");

      if (events.items == null || events.items!.isEmpty) {
        print("가져올 일정이 없습니다.");
        Fluttertoast.showToast(msg: "가져올 일정이 없습니다.");
        return;
      }

      Fluttertoast.showToast(msg: "${events.items!.length}개의 일정을 가져왔습니다.");
      await _addEventsToScheduleTable(events.items!);
    } catch (e) {
      print('일정 가져오기 오류: $e');
      Fluttertoast.showToast(msg: "일정 가져오기에 실패했습니다.");
    }
  }

  // 일정들을 스케줄 테이블에 추가하는 함수
  Future<void> _addEventsToScheduleTable(List<calendar.Event> events) async {
    try {
      // personal 캘린더 찾기
      final calendarData = await supabase
          .from('calendars')
          .select('id')
          .eq('user_id', user!.id)
          .eq('type', 'personal')
          .maybeSingle();

      if (calendarData == null) {
        Fluttertoast.showToast(msg: "개인 캘린더를 찾을 수 없습니다.");
        return;
      }

      final calendarId = calendarData['id'];

      // 스케줄 테이블에 추가
      int successCount = 0;
      for (var event in events) {
        try {
          await supabase.from('schedules').insert({
            'calendar_id': calendarId,
            'title': event.summary ?? '제목 없음',
            'started_at':
                event.start?.dateTime?.toIso8601String() ??
                event.start?.date?.toString(),
            'ended_at':
                event.end?.dateTime?.toIso8601String() ??
                event.end?.date?.toString(),
            'memo': event.description,
            'is_done': false,
            'is_repeat': false,
            'color_value': 0xFF4285F4,
          });
          successCount++;
        } catch (e) {
          print('일정 추가 실패: ${event.summary}, 오류: $e');
        }
      }

      Fluttertoast.showToast(msg: "$successCount개의 일정을 동기화했습니다.");
    } catch (e) {
      print('테이블 추가 오류: $e');
      Fluttertoast.showToast(msg: "일정 추가에 실패했습니다.");
    }
  }

  // 구글 캘린더 일정 삭제
  Future<void> _deleteGoogleCalendarEvents() async {
    try {
      // personal 캘린더 찾기
      final calendarData = await supabase
          .from('calendars')
          .select('id')
          .eq('user_id', user!.id)
          .eq('type', 'personal')
          .maybeSingle();

      if (calendarData == null) {
        Fluttertoast.showToast(msg: "개인 캘린더를 찾을 수 없습니다.");
        return;
      }

      final calendarId = calendarData['id'];

      // 구글에서 가져온 일정 삭제 (color_value로 구분)
      await supabase
          .from('schedules')
          .delete()
          .eq('calendar_id', calendarId)
          .eq('color_value', 0xFF4285F4);

      Fluttertoast.showToast(msg: "구글 캘린더 일정이 삭제되었습니다.");
    } catch (e) {
      print('일정 삭제 오류: $e');
      Fluttertoast.showToast(msg: "일정 삭제에 실패했습니다.");
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
