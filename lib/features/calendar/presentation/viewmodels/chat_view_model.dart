import 'package:flutter/material.dart';

import '../../../../main.dart';

/// 챗 뷰모델
class ChatViewModel extends ChangeNotifier {
  ChatViewModel(this.calendarId) {
    _init();
  }

  /// 채팅 입력
  final chatController = TextEditingController();

  /// 캘린더 아이디
  final int calendarId;

  /// 현재 로그인 유저
  final user = supabase.auth.currentUser;

  void _init() {
    messageFetch();
    timeFetch();
    isMeFetch();
  }

  /// 채팅을 수파베이스에 저장
  Future<void> chatInsert() async {
    await supabase.from('chat_messages').insert({
      'user_id': user!.id,
      'calendar_id': calendarId,
      'message': chatController.text,
      'created_at': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  /// 수파베이스 채팅 메시지 리스트로 불러오기
  List<String> messages = [];

  Future<void> messageFetch() async {
    final data = await supabase.from('chat_messages').select('message');

    messages = data.map((row) => row['message'] as String).toList();

    notifyListeners();
  }

  /// 수파베이스 채팅 시간 리스트로 불러오기
  List<String> time = [];

  Future<void> timeFetch() async {
    final data = await supabase.from('chat_messages').select('created_at');
    time = data.map((row) => row['created_at'] as String).toList();
    notifyListeners();
  }

  /// 내가 보낸 채팅인지 아닌지 리스트로 불러오기
  List<bool> isMe = [];

  Future<void> isMeFetch() async {
    final data = await supabase.from('chat_messages').select('user_id');
    isMe = data.map((row) {
      return row['user_id'] == user!.id;
    }).toList();
    notifyListeners();
  }
}
