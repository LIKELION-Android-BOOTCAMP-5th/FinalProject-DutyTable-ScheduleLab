import 'package:flutter/cupertino.dart';

class ProfileViewmodel extends ChangeNotifier {
  /// 수정버튼
  bool is_edit = false;

  ///캘린더 동기화 버튼
  bool is_sync = true;

  /// 알림 활성화
  bool is_active = true;

  /// 테마 드롭다운 리스트
  List<String> themeList = ["라이트모드", "다크모드", "시스템모드"];

  /// 드롭다운 기본값
  late String dropdownValue = themeList.first;

  /// 테마 선택된 값
  String selectedTheme = '';

  /// 닉네임 수정
  final nicknameContoller = TextEditingController();

  /// 닉네임 기본값
  var nickname = "닉네임";

  //테마 변경
  void setTheme(String value) {
    selectedTheme = value;
    notifyListeners();
  }

  //프로필 수정
  void setProfileEdit() {
    is_edit = !is_edit;
    notifyListeners();
  }

  // 동기화 연결,연결해제
  void googleSync() {
    is_sync = !is_sync;
    notifyListeners();
  }

  // 닉네임 텍스트 수정
  void editNickname() {
    final nickname = nicknameContoller.text.trim();
    notifyListeners();
  }

  // 테마 설정
  void editTheme() {
    notifyListeners();
  }

  //알림 토글
  void activeAlram() {
    is_active = !is_active;
    notifyListeners();
  }
}
