import 'dart:io';

import 'package:dutytable/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewmodel extends ChangeNotifier {
  ProfileViewmodel() {
    _init();
  }

  /// 현재 로그인 유저
  final user = supabase.auth.currentUser;

  /// 닉네임 수정
  final nicknameController = TextEditingController();

  /// 이메일
  String email = "";

  /// 프로필 url
  String? image = "";

  /// 닉네임
  String nickname = "닉네임";

  /// 수정버튼
  bool is_edit = false;

  ///캘린더 동기화 버튼
  bool is_sync = true;

  /// 알림 활성화
  bool is_active_notification = true;

  /// 테마 드롭다운 리스트
  List<String> themeList = ["라이트모드", "다크모드", "시스템모드"];

  /// 사용자가 테마 선택
  String selectedOption = "라이트모드";

  /// 닉네임 중복 여부
  bool is_overlapping = true;

  // 시작할때 닉네임,이메일,프로필 이미지 호출
  void _init() {
    fetchUser();
    loadTheme(); // 로컬저장한 테마 불러오기
  }

  //프로필 수정
  void setProfileEdit() {
    is_edit = !is_edit;
    is_overlapping = true;
    notifyListeners();
  }

  // 동기화 연결,연결해제
  void googleSync() {
    is_sync = !is_sync;
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

  // 사용자가 테마 선택하면 업데이트
  Future<dynamic> updateThmem(value) async {
    selectedOption = value;
    // if (selectedOption == "라이트모드") {
    //   AppTheme.lightTheme;
    // } else {
    //   AppTheme.darkTheme;
    // }
    notifyListeners();
  }

  //닉네임 수정한거 수파베이스에 반영하기
  Future<void> updateNickname(userId) async {
    await supabase
        .from('users')
        .update({'nickname': nicknameController.text})
        .eq('id', userId);
    this.nickname = nicknameController.text;
    notifyListeners();
  }

  // 닉네임,이메일, 프로필 사진 불러오기
  Future<void> fetchUser() async {
    final data = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .maybeSingle();
    nickname = data!['nickname'];
    nicknameController.text = nickname;
    email = data['email'];
    image = (data['profileurl'] ?? "");
    notifyListeners();
  }

  // 구글 연동하기
  Future<void> updateGoogleSync(userId) async {
    await supabase
        .from('users')
        .update({'is_google_calendar_connect': is_sync})
        .eq('id', userId);
    this.is_sync = is_sync;
    notifyListeners();
  }

  //알림 on/off하기
  Future<void> updateNotification(userId) async {
    await supabase
        .from('users')
        .update({'allowed_notification': is_active_notification})
        .eq('id', userId);
    this.is_active_notification = is_active_notification;
    notifyListeners();
  }

  // 이미지 피커로 갤러리에서 사진 가져오기
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  //이미지를 가져오기
  Future getImage(ImageSource imageSource) async {
    // 갤러리에서 선택된 이미지
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path); //이미지 가져와서 _image에 로컬 경로 저장
    }
    notifyListeners();
  }

  // 이미지 수파베이스 스토리지에 업로드 하기
  Future<String?> uploadStorage() async {
    // 선택한 사진이 없을때
    if (_image == null) {
      return null;
    }
    final file = File(_image!.path); // 스토리지에 올릴 이미지 로컬 경로
    final timestamp = DateTime.now().millisecondsSinceEpoch; // 타임스탬프

    await supabase.storage
        .from('profile-images')
        .upload('${user!.id}/profile_$timestamp.jpg', file); //사용자 폴더에 이미지 넣기
    final filePath =
        "${user!.id}/profile_$timestamp.jpg"; //파일 경로 : 유저아이디/프로필_타임스탬프.jpg

    // 테이블에 업데이트 할 public url 만들기
    final publicUrl = supabase.storage
        .from('profile-images')
        .getPublicUrl('${filePath}');
    notifyListeners();
    return publicUrl;
  }

  // 수파베이스에 저장
  Future<void> updateImage(userId, String? publicUrl) async {
    await supabase
        .from('users')
        .update({'profileurl': publicUrl}) // 사진 경로 업데이트
        .eq('id', userId);
    this.image = publicUrl;
    notifyListeners();
  }

  // 스토리지올리기 + 테이블 업데이트
  Future<void> upload() async {
    final publicUrl = await uploadStorage();
    await updateImage(user!.id, publicUrl);
    notifyListeners();
  }

  //  닉네임 조건 체크
  void nicknameCheck() {
    if (nicknameController.text.length > 1 &&
        nicknameController.text.length < 11 &&
        is_overlapping == false) {
      setProfileEdit();
    } else {}
    notifyListeners();
  }

  //  닉네임 중복
  Future<void> nicknameOverlapping() async {
    final count = await supabase
        .from('users')
        .select()
        .eq('nickname', nicknameController.text)
        .neq('id', user!.id);
    if (count.length > 0) {
      is_overlapping = true;
      Fluttertoast.showToast(msg: '중복된 닉네임입니다.');
    } else if (nicknameController.text.length < 2 ||
        nicknameController.text.length > 10) {
      Fluttertoast.showToast(msg: "닉네임은 2~10글자로 입력해야 합니다.");
    } else {
      is_overlapping = false;
      Fluttertoast.showToast(msg: "사용가능한 닉네임입니다.");
      updateNickname(user!.id);
      editNickname();
    }
    notifyListeners();
  }

  //로그아웃 하기
  Future<void> logout() async {
    await supabase.auth.signOut();
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }

  //테마 로컬 저장하기
  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(user!.id, selectedOption);
  }

  //테마 로컬 가져오기
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    selectedOption = prefs.getString(user!.id)!;
  }

  // 회원탈퇴
  Future<void> deleteUser() async {
    await supabase.from('users').delete().eq('id', user!.id);
  }
}
