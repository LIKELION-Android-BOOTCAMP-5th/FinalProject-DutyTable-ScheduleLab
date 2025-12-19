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

  // 날짜가 같은지 확인하는 헬퍼 함수
  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  // 날짜 표시 포맷
  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month.toString().padLeft(2, '0')}월 ${date.day.toString().padLeft(2, '0')}일';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
    final chatMessages = viewModel.chatMessages;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  controller: viewModel.scrollController,
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final currentMessage = chatMessages[index];

                    // 이전 메시지가 있는지 확인
                    final isFirstMessage = index == 0;
                    final previousMessage = isFirstMessage
                        ? null
                        : chatMessages[index - 1];

                    // 날짜가 변경되었는지 확인 (첫 메시지이거나 이전 메시지와 날짜가 다를 경우)
                    final bool showDateDivider =
                        isFirstMessage ||
                        !_isSameDay(
                          currentMessage.createdAt,
                          previousMessage!.createdAt,
                        );

                    return Column(
                      children: [
                        // 날짜가 변경되었을 때만 날짜 구분선 표시
                        if (showDateDivider)
                          CustomNextDayLine(
                            date: _formatDate(currentMessage.createdAt),
                          ),

                        // 커스텀 채팅 소유자에 따른 UI 변경 카드 사용
                        CustomChatCard(
                          isMyChat: currentMessage.isMe,
                          chatTime: currentMessage.time,
                          message: currentMessage.message,
                          image: currentMessage.image,
                          nickname: currentMessage.nickname,
                          id: currentMessage.id,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12.0);
                  },
                ),
              ),
            ),
            // 커스텀 채팅 입력창 사용
            CustomInputChatMessageBox(),
          ],
        ),
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
              onTap: () async {
                await Future.delayed(Duration(milliseconds: 1000));
                if (viewModel.scrollController.hasClients) {
                  viewModel.scrollController.animateTo(
                    viewModel.scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  );
                }
              },
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
  final String date;

  /// 커스텀 날짜 구분선
  const CustomNextDayLine({super.key, required this.date});

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
            date,
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

  /// 프로필 이미지
  final image;

  /// 닉네임
  final nickname;

  /// 채팅 아이디
  final id;

  /// 커스텀 채팅 소유자에 따른 UI 변경 카드
  const CustomChatCard({
    super.key,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
    this.image,
    required this.nickname,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    if (isMyChat) {
      // 내 채팅 UI 카드 사용
      return CustomMyChatCard(
        isMyChat: isMyChat,
        chatTime: chatTime,
        message: message,
        image: image,
        nickname: nickname,
        id: id,
      );
    }
    // 다른 유저 채팅 UI 카드 사용
    return CustomOtherChatCard(
      isMyChat: isMyChat,
      chatTime: chatTime,
      message: message,
      image: image,
      nickname: nickname,
      id: id,
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

  /// 프로필 이미지
  final image;

  /// 닉네임
  final nickname;

  /// 채팅 아이디
  final id;

  /// 내 채팅 UI 카드
  const CustomMyChatCard({
    super.key,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
    this.image,
    required this.nickname,
    required this.id,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  nickname,
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.right,
                ),
              ),
              CustomChatBox(
                color: Colors.blue,
                isMyChat: isMyChat,
                chatTime: chatTime,
                message: message,
                image: image,
                id: id,
                nickname: nickname,
              ),
            ],
          ),
          // 커스텀 프로필 이미지 박스 사용
          CustomChatProfileImageBox(width: 36, height: 36, imageUrl: image),
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

  /// 프로필 이미지
  final image;

  /// 닉네임
  final nickname;

  /// 채팅 아이디
  final id;

  /// 다른 유저 채팅 UI 카드
  const CustomOtherChatCard({
    super.key,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
    this.image,
    required this.nickname,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        // 커스텀 프로필 이미지 박스 사용
        CustomChatProfileImageBox(width: 36, height: 36, imageUrl: image),
        // 커스텀 채팅 박스 사용
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                nickname,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.left,
              ),
            ),
            CustomChatBox(
              color: Colors.grey,
              isMyChat: isMyChat,
              chatTime: chatTime,
              message: message,
              image: image,
              nickname: nickname,
              id: id,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomChatProfileImageBox extends StatelessWidget {
  final double width;
  final double height;
  final String? imageUrl;

  /// 커스텀 프로필 이미지 박스
  const CustomChatProfileImageBox({
    super.key,
    required this.width,
    required this.height,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
      // child: Image.network("${imageUrl}"),
      child: (imageUrl == null)
          ? ClipOval(child: Icon(Icons.account_circle, size: 35))
          : ClipOval(child: Image.network(imageUrl!)),
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

  /// 프로필 이미지
  final image;

  /// 닉네임
  final nickname;

  /// 채팅 아이디
  final id;

  /// 커스텀 채팅 박스
  const CustomChatBox({
    super.key,
    required this.color,
    required this.isMyChat,
    required this.chatTime,
    required this.message,
    this.image,
    required this.nickname,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();
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
            child: (message.length > 1000)
                ? GestureDetector(
                    onTap: () => viewModel.isFold(id),

                    child: Text(
                      message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: viewModel.chatLength(id),
                    ),
                  )
                : Text(message),
          ),
        ),
        Text(chatTime, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
