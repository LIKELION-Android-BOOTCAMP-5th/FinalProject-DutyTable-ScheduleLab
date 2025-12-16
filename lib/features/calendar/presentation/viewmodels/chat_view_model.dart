import 'package:dutytable/extensions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';
import '../../../../supabase_manager.dart';

enum ViewState { loading, success, error }

/// 챗 뷰모델
class ChatViewModel extends ChangeNotifier {
  ViewState _state = ViewState.loading;

  ViewState get state => _state;

  /// 채팅 입력
  final chatController = TextEditingController();

  /// 캘린더 아이디
  final int calendarId;

  /// 현재 로그인 유저
  final user = supabase.auth.currentUser;

  ///리얼타임 채널
  RealtimeChannel? channel;

  ///채팅 메시지
  List<String> messages = [];

  ///채팅 시간
  List<String> time = [];

  late int hour;

  ///내 채팅인지 아닌지
  List<bool> isMe = [];

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

  // 채팅을 수파베이스에 저장
  Future<void> chatInsert() async {
    await supabase.from('chat_messages').insert({
      'user_id': user!.id,
      'calendar_id': calendarId,
      'message': chatController.text,
      'created_at': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  // 수파베이스 채팅 메시지 리스트로 불러오기
  Future<void> messageFetch() async {
    final data = await supabase.from('chat_messages').select('message');
    messages = data.map((row) => row['message'] as String).toList();
  }

  // 수파베이스 채팅 시간 리스트로 불러오기
  Future<void> timeFetch() async {
    final data = await supabase.from('chat_messages').select('created_at');
    time = data.map((row) {
      return (row['created_at'] as String).toChatTime();
    }).toList();
  }

  // 내가 보낸 채팅인지 아닌지 리스트로 불러오기
  Future<void> isMeFetch() async {
    final data = await supabase.from('chat_messages').select('user_id');
    isMe = data.map((row) {
      return row['user_id'] == user!.id;
    }).toList();
    notifyListeners();
  }

  //새로운 캘린더인지 구분하기
  Future<bool> isNew(calendarId) async {
    final result = await supabase
        .from('chat_messages')
        .select()
        .eq('calendar_id', calendarId);
    if (result.isEmpty) {
      return true; // 새 캘린더이다
    } else {
      return false;
    }
  }

  // 채팅방데이터 불러오기
  Future<void> fetchChatMessages() async {
    if (await isNew(calendarId) == true) {
      _state = ViewState.success;
    } else {
      await messageFetch();
      await timeFetch();
      await isMeFetch();
      channel = _subcribeMessageEvent();
      _state = ViewState.success;
      notifyListeners();
    }
  }
}
