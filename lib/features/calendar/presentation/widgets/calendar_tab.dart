import 'package:dutytable/extensions.dart';
import 'package:flutter/material.dart';
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
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(16),
                    child: SizedBox.expand(
                      child: Container(
                        color: Colors.black,
                        child: Column(
                          children: [
                            Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
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
