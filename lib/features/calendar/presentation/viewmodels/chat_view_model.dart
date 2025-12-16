import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';
import '../../../../supabase_manager.dart';

enum ViewState { loading, success, error }

/// 챗 뷰모델
class ChatViewModel extends ChangeNotifier {
  ViewState _state = ViewState.loading;

  ViewState get state => _state;
  ChatViewModel(this.calendarId) {
    if (messages.isNotEmpty) {
      // 메시지가 있으면 성공
      _state = ViewState.success;
    } else {
      // 없으면 fetchChatMessages()
      _state = ViewState.loading;
      fetchChatMessages();
    }
  }

  late RealtimeChannel channel;

  /// 채팅 입력
  final chatController = TextEditingController();

  /// 캘린더 아이디
  final int calendarId;

  /// 현재 로그인 유저
  final user = supabase.auth.currentUser;

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
  }

  /// 수파베이스 채팅 시간 리스트로 불러오기
  List<String> time = [];
  late int hour;

  Future<void> timeFetch() async {
    final data = await supabase.from('chat_messages').select('created_at');
    time = data.map((row) {
      final createdAtString = row['created_at'] as String;
      final createdAt = DateTime.parse(createdAtString);
      return '${createdAt.hour}시 ${createdAt.minute}분';
    }).toList();
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

  final ScrollController scrollController = ScrollController();
  // 리얼타임 구독하기
  RealtimeChannel _subcribeMessageEvent() {
    return SupabaseManager.shared.supabase
        .channel('chatting')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          callback: (payload) {
            final newMessage = payload.newRecord;

            final newChatMessage = newMessage['message'];
            final createdAtString = newMessage['created_at'] as String;
            final createdAt = DateTime.parse(createdAtString);
            final newChatUserid = newMessage['user_id'];

            messages.add(newChatMessage);
            time.add('${createdAt.hour}시 ${createdAt.minute}분');
            isMe.add(newChatUserid == user!.id);
            print("Change received: ${payload.toString()}");
            notifyListeners();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastEaseInToSlowEaseOut,
                );
              }
            });
          },
        )
        .subscribe();
  }

  Future<void> fetchChatMessages() async {
    await messageFetch();
    await timeFetch();
    await isMeFetch();
    channel = _subcribeMessageEvent();
    _state = ViewState.success;
    notifyListeners();
  }
}
