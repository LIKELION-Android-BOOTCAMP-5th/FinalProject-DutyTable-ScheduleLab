import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/calendar/data/datasources/chat_data_source.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_manager.dart';
import '../../../../main.dart';

enum ViewState { loading, success, error }

class ChatMessage {
  final String message;
  final String time;
  final DateTime createdAt; // 날짜 비교를 위한 원본 DateTime (날짜 구분선용)
  final bool isMe;
  final String? image;
  final String nickname;
  final int id;

  ChatMessage({
    required this.message,
    required this.time,
    required this.createdAt,
    required this.isMe,
    required this.image,
    required this.nickname,
    required this.id,
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

  Map<int, bool> chatfold = {};

  int? chatLength(int id) {
    bool isFolded = chatfold[id] ?? true;
    if (isFolded) {
      return 5;
    } else {
      return 50;
    }
  }

  void isFold(int id) {
    chatfold[id] = !(chatfold[id] ?? true);
    notifyListeners();
  }

  // 리얼타임 구독하기
  RealtimeChannel _subscribeMessageEvent() {
    return SupabaseManager.shared.supabase
        .channel('chatting')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'calendar_id',
            value: calendarId,
          ),
          callback: (payload) async {
            final newMessage = payload.newRecord;
            final createdAtString = newMessage['created_at'] as String;
            final createdAt = DateTime.parse(createdAtString).toLocal();
            final senderId = newMessage['user_id'] as String;
            final data = await ChatDataSource.instance
                .fetchNewChatImageNickname(senderId);
            final userImage = data['profile_url'] ?? "";
            final nickname = data['nickname'];
            print("🚨${data['nickname']}");
            final newChatMessage = ChatMessage(
              id: newMessage['id'] as int,
              image: (userImage.isNotEmpty) ? userImage as String? : null,
              message: newMessage['message'] as String,
              time: createdAtString.toChatTime(),
              createdAt: createdAt,
              isMe: newMessage['user_id'] == user!.id,
              nickname: nickname,
            );

            chatMessages.add(newChatMessage);
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
    final chatMessage = chatController.text;
    // 메시지가 비어있으면 전송하지 않음
    if (chatController.text.trim().isEmpty) return;
    await ChatDataSource.instance.chatInsert(chatMessage, calendarId);
    chatController.clear();
  }

  // 모든 데이터를 한 번에 가져오는 함수로 통합
  Future<void> fetchChatMessages() async {
    _state = ViewState.loading;
    try {
      final data = await ChatDataSource.instance.fetchChatMessages(calendarId);
      chatMessages = data.map((row) {
        final createdAtString = row['created_at'] as String;
        final createdAt = DateTime.parse(createdAtString).toLocal();
        final users = row['users'];

        return ChatMessage(
          id: row['id'] as int,
          message: row['message'] as String,
          time: createdAtString.toChatTime(),
          createdAt: createdAt,
          isMe: row['user_id'] == user!.id,
          image: users != null ? users['profile_url'] as String? : null,
          nickname: users['nickname'],
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

  // last_read_at 업데이트 하기
  Future<void> updateLastReadAt(String userId, int calendarId) async {
    await ChatDataSource.instance.updateLastReadAt(
      userId: userId,
      calendarId: calendarId,
      payload: {'last_read_at': DateTime.now().toUtc().toIso8601String()},
    );
  }

  @override
  Future<void> dispose() async {
    await updateLastReadAt(user!.id, calendarId);
    channel?.unsubscribe();
    chatController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
