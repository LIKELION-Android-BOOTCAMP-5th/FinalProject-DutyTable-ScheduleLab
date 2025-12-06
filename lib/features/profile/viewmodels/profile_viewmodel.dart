import 'package:dutytable/main.dart';
import 'package:flutter/cupertino.dart';

class ProfileViewmodel extends ChangeNotifier {
  /// 현재 로그인 유저
  final user = supabase.auth.currentUser;

  /// 닉네임 수정
  final nicknameController = TextEditingController();

  /// 이메일
  String email = "";

  /// 닉네임
  String nickname = "닉네임";

  /// 수정버튼
  bool is_edit = false;

  ///캘린더 동기화 버튼
  bool is_sync = true;

  /// 알림 활성화
  bool is_active = true;

  /// 테마 드롭다운 리스트
  List<String> themeList = ["라이트모드", "다크모드", "시스템모드"];

  /// 사용자가 테마 선택
  String selectedOption = "option1";

  // 시작할때 닉네임,이메일 호출
  void init() {
    fetchNickname();
    fetchEmail();
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
    final nickname = nicknameController.text.trim();
    notifyListeners();
  }

  //알림 토글
  void activeAlram() {
    is_active = !is_active;
    notifyListeners();
  }

  // 사용자가 테마 선택하면 업데이트
  void updateThmem(value) {
    selectedOption = value;
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

  // 닉네임 불러오기
  Future<void> fetchNickname() async {
    final data = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .maybeSingle();
    nickname = data!['nickname'];
    notifyListeners();
  }

  // 이메일 불러오기
  Future<void> fetchEmail() async {
    final data = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .maybeSingle();
    email = data!['email'];
    notifyListeners();
  }
}
