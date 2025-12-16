import 'package:dutytable/features/calendar/presentation/viewmodels/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/calendar_model.dart';

class ChatTab extends StatelessWidget {
  final CalendarModel? calendar;

  /// 채팅 탭(provider 주입)
  const ChatTab({super.key, this.calendar});

  @override
  Widget build(BuildContext context) {
    // 챗 뷰모델주입
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(calendar?.id ?? 0),
      child: _ChatTab(),
    );
  }
}

class _ChatTab extends StatelessWidget {
  /// 채팅 탭(private)
  const _ChatTab({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    // 내가 보낸 채팅/ 상대방이 보낸 채팅
    final isMe = viewModel.isMe;
    //채팅 보낸 시간
    final time = viewModel.time;
    // 채팅 메시지
    final chat = viewModel.messages;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                controller: viewModel.scrollController,
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // 커스텀 날짜 구분선 사용
                      CustomNextDayLine(),
                      // 커스텀 채팅 소유자에 따른 UI 변경 카드 사용
                      CustomChatCard(
                        // 내가 보낸 채팅인가
                        isMyChat: isMe[index],
                        // 채팅 보낸 시간
                        chatTime: time[index],
                        // 채팅 메세지
                        message: chat[index],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20.0);
                },
              ),
            ),
          ),
          // 커스텀 채팅 입력창 사용
          CustomInputChatMessageBox(),
        ],
      ),
    );
  }
}

class CustomInputChatMessageBox extends StatelessWidget {
  /// 커스텀 채팅 입력창
  const CustomInputChatMessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: TextField(
              controller: viewModel.chatController,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print("전송 눌림");
              viewModel.chatInsert();
              viewModel.chatController.clear();
            },
            // 버튼 크기
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "전송",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNextDayLine extends StatelessWidget {
  /// 커스텀 날짜 구분선
  const CustomNextDayLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "0000년 00월 00일",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomChatCard extends StatelessWidget {
  /// 내가 보낸 채팅인가
  final isMyChat;

  /// 채팅 보낸 시간
  final chatTime;

  /// 채팅 메세지
  final message;

  /// 커스텀 채팅 소유자에 따른 UI 변경 카드
  const CustomChatCard({
    super.key,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (isMyChat) {
      // 내 채팅 UI 카드 사용
      return CustomMyChatCard(
        isMyChat: isMyChat,
        chatTime: chatTime,
        message: message,
      );
    }
    // 다른 유저 채팅 UI 카드 사용
    return CustomOtherChatCard(
      isMyChat: isMyChat,
      chatTime: chatTime,
      message: message,
    );
  }
}

class CustomMyChatCard extends StatelessWidget {
  /// 내가 보낸 채팅인가
  final bool isMyChat;

  /// 채팅 보낸 시간
  final String chatTime;

  /// 채팅 메세지
  final String message;

  /// 내 채팅 UI 카드
  const CustomMyChatCard({
    super.key,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 12,
        children: [
          // 커스텀 채팅 박스 사용
          CustomChatBox(
            color: Colors.blue,
            isMyChat: isMyChat,
            chatTime: chatTime,
            message: message,
          ),
          // 커스텀 프로필 이미지 박스 사용
          CustomChatProfileImageBox(width: 36, height: 36),
        ],
      ),
    );
  }
}

class CustomOtherChatCard extends StatelessWidget {
  /// 내가 보낸 채팅인가
  final bool isMyChat;

  /// 채팅 보낸 시간
  final String chatTime;

  /// 채팅 메세지
  final String message;

  /// 다른 유저 채팅 UI 카드
  const CustomOtherChatCard({
    super.key,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        // 커스텀 프로필 이미지 박스 사용
        CustomChatProfileImageBox(width: 36, height: 36),
        // 커스텀 채팅 박스 사용
        CustomChatBox(
          color: Colors.grey,
          isMyChat: isMyChat,
          chatTime: chatTime,
          message: message,
        ),
      ],
    );
  }
}

class CustomChatProfileImageBox extends StatelessWidget {
  final double width;
  final double height;

  /// 커스텀 프로필 이미지 박스
  const CustomChatProfileImageBox({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
    );
  }
}

class CustomChatBox extends StatelessWidget {
  /// 채팅 메세지 박스 컬러
  final Color color;

  /// 내가 보낸 채팅인가
  final bool isMyChat;

  /// 채팅 보낸 시간
  final String chatTime;

  /// 채팅 메세지
  final String message;

  /// 커스텀 채팅 박스
  const CustomChatBox({
    super.key,
    required this.color,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMyChat
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            // 최대 너비
            maxWidth: 250,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
          ),
        ),
        Text(chatTime, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
