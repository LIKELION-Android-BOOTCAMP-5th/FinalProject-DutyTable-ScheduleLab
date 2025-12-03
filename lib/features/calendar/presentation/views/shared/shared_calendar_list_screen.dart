import 'package:flutter/material.dart';

import '../../widgets/duty_table_appbar.dart';

class SharedCalendarListScreen extends StatelessWidget {
  /// 공유 캘린더 목록 화면
  const SharedCalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SharedCalendarListScreen();
  }
}

class _SharedCalendarListScreen extends StatelessWidget {
  const _SharedCalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DutyTableAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey, width: 1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: Row(
                      children: [
                        // LEFT: 아이콘 박스
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A7BFF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            "assets/images/calendar_logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 16),

                        // MIDDLE: 텍스트 영역
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 제목 + 멤버수 뱃지
                              Row(
                                children: [
                                  Text(
                                    "팀 프로젝트",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      "99+명",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // 다음 일정
                              Text(
                                "다음 일정: 12월 5일",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // RIGHT: 읽지 않은 메시지
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "99+",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
