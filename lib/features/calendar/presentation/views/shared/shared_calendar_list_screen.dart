import 'dart:ui';

import 'package:flutter/material.dart';
import '../../widgets/duty_table_appbar.dart';

class SharedCalendarListScreen extends StatefulWidget {
  const SharedCalendarListScreen({super.key});

  @override
  State<SharedCalendarListScreen> createState() =>
      _SharedCalendarListScreenState();
}

class _SharedCalendarListScreenState extends State<SharedCalendarListScreen> {
  bool deleteMode = false; // 삭제 모드 ON/OFF
  bool isSelected = false; // 카드 체크 상태
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DutyTableAppBar(
        deleteMode: deleteMode,
        onDeletePressed: () {
          setState(() {
            deleteMode = !deleteMode;
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            _buildCalendarCard(
              title: "팀 프로젝트",
              deletable: true,
              isAdmin: false,
            ),

            const SizedBox(height: 12),

            _buildCalendarCard(title: "부서 공지", deletable: false, isAdmin: true),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard({
    required String title,
    required bool deletable,
    required bool isAdmin,
  }) {
    final applyBlur = deleteMode && isAdmin;

    return Stack(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected && !applyBlur ? Colors.red : Colors.grey,
              width: isSelected && !applyBlur ? 2 : 1,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
              children: [
                // LEFT ICON
                Container(
                  width: 40,
                  height: 40,
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

                // MIDDLE TITLE & DATE
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
                              fontSize: 14,
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
                                fontSize: 10,
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
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // RIGHT SIDE
                if (!deleteMode)
                  // 기본 뱃지
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "99+",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  // 삭제 모드일 때
                  !isAdmin
                      ? Checkbox(
                          value: isSelected,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              isSelected = value ?? false;
                            });
                          },
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "삭제 불가",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ),
              ],
            ),
          ),
        ),

        if (applyBlur)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.6), // 흐릿한 흰색 오버레이
                ),
              ),
            ),
          ),
      ],
    );
  }
}
