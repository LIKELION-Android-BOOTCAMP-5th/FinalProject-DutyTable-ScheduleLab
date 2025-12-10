import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/widgets/custom_floatingactionbutton.dart';
import '../viewmodels/schedule_view_model.dart';

class CalendarTab extends StatelessWidget {
  /// 캘린더 탭(provider 주입)
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 스케쥴 뷰모델 주입
    return ChangeNotifierProvider(
      create: (context) => ScheduleViewModel(),
      child: _CalendarTab(),
    );
  }
}

class _CalendarTab extends StatelessWidget {
  /// 캘린더 탭(local)
  const _CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 스케쥴 뷰모델 주입
    return Consumer<ScheduleViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          // 테이블 캘린더 라이브러리 사용
          body: TableCalendar(
            shouldFillViewport: true,
            firstDay: DateTime.utc(2000, 1, 1), // 달력 시작
            lastDay: DateTime.utc(2100, 12, 31), // 달력 종료
            focusedDay: viewModel.selectedDay, // 오늘
            locale: 'ko_KR', // 국가
            currentDay: viewModel.selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              viewModel.changeSelectedDay(selectedDay);
            },

            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE5E5E5)),
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.chevron_left),
                ),
              ),
              rightChevronIcon: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE5E5E5)),
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.chevron_right),
                ),
              ),
            ),

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(16),
                    child: SizedBox.expand(
                      child: Container(
                        color: viewModel.tasksDate.contains(day.toPureDate())
                            ? Colors.grey
                            : Colors.transparent,
                        child: Column(children: [Text('${day.day}')]),
                      ),
                    ),
                  ),
                );
              },

              todayBuilder: (context, day, focusedDay) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: AppColors.background(context),
                        insetPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 40,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _ScheduleDialogContent(day: day),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text('${day.day}', style: TextStyle(color: Colors.white)),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            "헬스장 가기",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          floatingActionButton: CustomFloatingActionButton(),
        );
      },
    );
  }
}

class _ScheduleDialogContent extends StatelessWidget {
  final DateTime day;

  const _ScheduleDialogContent({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> schedules = [
      {
        "emoji": "😐",
        "title": "팀 회의",
        "calendar": "공유 캘린더",
        "color": 0xFFDDEAFF,
      },
      {"emoji": "😐", "title": "운동", "calendar": "내 캘린더", "color": 0xFFE1F7E6},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 상단 날짜 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${day.day}",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    _weekday(day.weekday),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Text(
                "선택삭제",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.commonBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        const Divider(color: AppColors.commonGrey, height: 1),

        const SizedBox(height: 10),

        // 일정 리스트
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: schedules.length,
          itemBuilder: (_, index) {
            final item = schedules[index];

            return GestureDetector(
              onTap: () {
                // 다이얼로그 끄기
                context.pop();
                context.push("/personal/detail");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(item["color"]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(item["emoji"], style: TextStyle(fontSize: 26)),

                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item["calendar"],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  String _weekday(int w) {
    return ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'][w - 1];
  }
}
