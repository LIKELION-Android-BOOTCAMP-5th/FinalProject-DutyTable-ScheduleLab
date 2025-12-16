import 'package:dutytable/extensions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';
import '../../../../supabase_manager.dart';

enum ViewState { loading, success, error }

class ChatMessage {
  final String message;
  final String time;
  final DateTime createdAt; // 날짜 비교를 위한 원본 DateTime (날짜 구분선용)
  final bool isMe;

  ChatMessage({
    required this.message,
    required this.time,
    required this.createdAt,
    required this.isMe,
  });
}

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

  /// 채팅 메시지 리스트
  List<ChatMessage> chatMessages = [];

  final ScrollController scrollController = ScrollController();

  // 리얼타임 구독하기
  RealtimeChannel _subscribeMessageEvent() {
    return SupabaseManager.shared.supabase
        .channel('chatting')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          callback: (payload) {
            final newMessage = payload.newRecord;
            final createdAtString = newMessage['created_at'] as String;
            final createdAt = DateTime.parse(createdAtString).toLocal();

            final newChatMessage = ChatMessage(
              message: newMessage['message'] as String,
              time: createdAtString.toChatTime(),
              createdAt: createdAt,
              isMe: newMessage['user_id'] == user!.id,
            );

            chatMessages.add(newChatMessage);
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
    fetchChatMessages();
  }

  // 채팅을 수파베이스에 저장
  Future<void> chatInsert() async {
    // 메시지가 비어있으면 전송하지 않음
    if (chatController.text.trim().isEmpty) return;

    await supabase.from('chat_messages').insert({
      'user_id': user!.id,
      'calendar_id': calendarId,
      'message': chatController.text,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });
    chatController.clear();
  }

  // 모든 데이터를 한 번에 가져오는 함수로 통합
  Future<void> fetchChatMessages() async {
    _state = ViewState.loading;
    try {
      final data = await supabase
          .from('chat_messages')
          .select('message, created_at, user_id')
          .eq('calendar_id', calendarId)
          .order('created_at', ascending: true);

      chatMessages = data.map((row) {
        final createdAtString = row['created_at'] as String;
        final createdAt = DateTime.parse(createdAtString).toLocal();

        return ChatMessage(
          message: row['message'] as String,
          time: createdAtString.toChatTime(),
          createdAt: createdAt,
          isMe: row['user_id'] == user!.id,
        );
      }).toList();

      channel = _subscribeMessageEvent();

      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      print('채팅 메시지 로딩 오류: $e');
    } finally {
      notifyListeners();
      // 초기 로딩 후 스크롤을 맨 아래로 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  void dispose() {
    channel?.unsubscribe();
    chatController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
