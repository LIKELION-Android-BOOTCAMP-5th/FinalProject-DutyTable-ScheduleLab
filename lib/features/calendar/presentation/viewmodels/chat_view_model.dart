import 'dart:convert';

import 'package:dutytable/core/utils/extensions.dart';
import 'package:dutytable/features/calendar/domain/entities/detect_result.dart';
import 'package:dutytable/features/calendar/domain/entities/detected_schedule.dart';
import 'package:dutytable/features/calendar/domain/usecases/detect_schedule_use_case.dart';
import 'package:dutytable/features/calendar/domain/usecases/fetch_chat_messages_use_case.dart';
import 'package:dutytable/features/calendar/domain/usecases/update_last_read_at_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../../../main.dart';
import '../../domain/usecases/chat_insert_use_case.dart';
import '../../domain/usecases/fetch_user_info_use_case.dart';
import '../../domain/usecases/subscribe_messages_use_case.dart';

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
  final ChatInsertUseCase _chatInsertUseCase = getIt<ChatInsertUseCase>();
  final FetchChatMessagesUseCase _fetchChatMessagesUseCase =
      getIt<FetchChatMessagesUseCase>();
  final UpdateLastReadAtUseCase _updateLastReadAtUseCase =
      getIt<UpdateLastReadAtUseCase>();
  final FetchUserInfoUseCase _fetchUserInfoUseCase =
      getIt<FetchUserInfoUseCase>();
  final SubscribeMessagesUseCase _subscribeMessagesUseCase =
      getIt<SubscribeMessagesUseCase>();
  final DetectScheduleUseCase _detectScheduleUseCase =
      getIt<DetectScheduleUseCase>();
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

  /// AI 감지된 일정 리스트
  List<DetectedSchedule> detectedSchedules = [];

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
    return _subscribeMessagesUseCase(calendarId, (newMessage) async {
      // 인라인 콜백
      final createdAtString = newMessage['created_at'] as String;
      final createdAt = DateTime.parse(createdAtString).toLocal();
      final senderId = newMessage['user_id'] as String;

      // UseCase로 사용자 정보 가져오기
      final data = await _fetchUserInfoUseCase(senderId);

      final userImage = data['profile_url'] ?? "";
      final nickname = data['nickname'];

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
    });
  }

  ChatViewModel(this.calendarId) {
    _loadDetectedSchedules(); // 저장된 감지된 일정 로드
    fetchChatMessages();
  }

  /// SharedPreferences에서 감지된 일정 로드
  Future<void> _loadDetectedSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson = prefs.getStringList('detected_schedules') ?? [];

      detectedSchedules = schedulesJson
          .map(
            (json) => DetectedSchedule.fromJson(
              jsonDecode(json) as Map<String, dynamic>,
            ),
          )
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('감지된 일정 로드 실패: $e');
    }
  }

  /// SharedPreferences에 감지된 일정 저장
  Future<void> _saveDetectedSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson = detectedSchedules
          .map((s) => jsonEncode(s.toJson()))
          .toList();
      await prefs.setStringList('detected_schedules', schedulesJson);
    } catch (e) {
      debugPrint('감지된 일정 저장 실패: $e');
    }
  }

  // 채팅을 수파베이스에 저장
  Future<void> chatInsert() async {
    final msg = chatController.text.trim();
    // 메시지가 비어있으면 전송하지 않음
    if (msg.isEmpty) return;
    await _chatInsertUseCase(msg, calendarId);
    chatController.clear();
    _detectAndAddSchedule(msg); // await 없음 - 채팅 전송에 영향 없음
  }

  /// 메시지에서 일정 감지 (fire-and-forget)
  /// 이전 5개 메시지와 함께 분석하여 여러 메시지에 걸친 일정도 감지
  Future<void> _detectAndAddSchedule(String message) async {
    try {
      // 이전 메시지 5개 추출 (사용자 메시지만, 최근순)
      final previousMessages = <String>[];
      for (
        int i = chatMessages.length - 1;
        i >= 0 && previousMessages.length < 5;
        i--
      ) {
        previousMessages.insert(0, chatMessages[i].message);
      }

      final result = await _detectScheduleUseCase(
        message,
        previousMessages: previousMessages,
      );

      if (result != null) {
        switch (result) {
          case ScheduleDetected(:final schedule):
            // 날짜+시간이 있는 경우 새 알림 추가
            detectedSchedules.add(schedule);

            // 11개 이상이면 가장 오래된 것 삭제 (최대 10개 유지)
            if (detectedSchedules.length > 10) {
              detectedSchedules.removeAt(0);
            }

          case PlaceOnlyDetected(:final place):
            // 장소만 있는 경우 가장 최근 알림에 장소 업데이트
            if (detectedSchedules.isNotEmpty) {
              final lastIndex = detectedSchedules.length - 1;
              detectedSchedules[lastIndex] =
                  detectedSchedules[lastIndex].copyWith(place: place);
            }
        }

        notifyListeners();
        await _saveDetectedSchedules(); // 저장
      }
    } catch (e) {
      debugPrint('일정 감지 실패 (무시됨): $e');
    }
  }

  /// 감지된 일정 제거
  Future<void> removeDetectedSchedule(int index) async {
    if (index >= 0 && index < detectedSchedules.length) {
      detectedSchedules.removeAt(index);
      notifyListeners();
      await _saveDetectedSchedules(); // 저장
    }
  }

  /// AI 감지 일정으로 일정 추가 화면 열기
  void addScheduleFromAi(Object? context, int index) {
    if (index < 0 || index >= detectedSchedules.length) return;
    final schedule = detectedSchedules[index];
    if (context is BuildContext) {
      context.push(
        '/schedule/add',
        extra: {
          'calendarId': calendarId,
          'date': DateTime.tryParse(schedule.date),
          'detectedSchedule': schedule,
        },
      );
    }
  }

  // 모든 데이터를 한 번에 가져오는 함수로 통합
  Future<void> fetchChatMessages() async {
    _state = ViewState.loading;
    try {
      final data = await _fetchChatMessagesUseCase(calendarId);
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
      debugPrint('채팅 메시지 로딩 오류: $e');
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
  Future<void> updateLastReadAt(
    String userId,
    int calendarId,
    DateTime last_read_at,
  ) async {
    await _updateLastReadAtUseCase(userId, calendarId, last_read_at);
  }

  @override
  Future<void> dispose() async {
    await updateLastReadAt(user!.id, calendarId, DateTime.now().toUtc());
    channel?.unsubscribe();
    chatController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool aiScheduleFold = true;

  void toggleAiScheduleFold() {
    aiScheduleFold = !aiScheduleFold;
    notifyListeners();
  }
}
