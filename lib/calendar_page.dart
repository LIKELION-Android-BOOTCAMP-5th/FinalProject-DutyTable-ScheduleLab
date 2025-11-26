import 'package:dutytable/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_view_model.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "당번",
      //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
      //   ),
      // ),
      body: SafeArea(
        child: Consumer<CalendarViewModel>(
          builder: (context, viewmodel, child) {
            return TableCalendar(
              shouldFillViewport: true,
              firstDay: DateTime.utc(2000, 1, 1), // 달력 시작
              lastDay: DateTime.utc(2100, 12, 31), // 달력 종료
              focusedDay: viewmodel.selectedDay, // 오늘
              locale: 'ko_KR', // 국가
              currentDay: viewmodel.selectedDay,
              onDaySelected: (selectedDay, focusedDay) {
                viewmodel.changeSelectedDay(selectedDay);
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
                          color: viewmodel.tasksDate.contains(day.toPureDate())
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
            );
          },
        ),
      ),
    );
  }
}
