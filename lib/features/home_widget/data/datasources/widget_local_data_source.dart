import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../../schedule/data/models/schedule_model.dart';

abstract class WidgetLocalDataSource {
  Future<void> updateWidget(Map<String, String> data);
  Future<void> updateCalendarWidget(List<ScheduleModel> schedules);
}

class WidgetLocalDataSourceImpl implements WidgetLocalDataSource {
  static const String appGroupId = 'group.com.schedulelab.dutytable';
  static const String iosWidgetName = 'MyWidgetExtension';
  static const String androidWidgetName = 'MyWidgetProvider';

  @override
  Future<void> updateWidget(Map<String, String> data) async {
    await HomeWidget.setAppGroupId(appGroupId);

    for (var entry in data.entries) {
      await HomeWidget.saveWidgetData<String>(entry.key, entry.value);
    }

    await HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      androidName: androidWidgetName,
    );
  }

  @override
  Future<void> updateCalendarWidget(List<ScheduleModel> schedules) async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final firstDayOffset = firstDayOfMonth.weekday % 7;

    Map<String, String> calendarMap = {};
    for (var day = 1; day <= lastDayOfMonth.day; day++) {
      final currentDay = DateTime(now.year, now.month, day);
      final daySchedules = schedules
          .where(
            (s) =>
                s.startedAt.year == currentDay.year &&
                s.startedAt.month == currentDay.month &&
                s.startedAt.day == currentDay.day,
          )
          .toList();

      if (daySchedules.isNotEmpty) {
        final first = daySchedules.first;
        calendarMap[day.toString()] = "${first.title}|${first.colorValue}";
      }
    }

    // 위젯에 보낼 날짜별 일정 문자열 헬퍼
    String getDutiesForDate(DateTime date) {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final list = schedules
          .where((s) => DateFormat('yyyy-MM-dd').format(s.startedAt) == dateStr)
          .map((e) => e.title);
      return list.isEmpty ? "일정 없음" : list.join(', ');
    }

    final Map<String, String> widgetData = {
      'date_key': DateFormat('M월 d일 (E)', 'ko_KR').format(now),
      'today_duties': getDutiesForDate(now),
      'tomorrow_date': DateFormat(
        'M월 d일 (E)',
        'ko_KR',
      ).format(now.add(const Duration(days: 1))),
      'tomorrow_duties': getDutiesForDate(now.add(const Duration(days: 1))),
      'calendar_json': jsonEncode(calendarMap),
      'first_day_offset': firstDayOffset.toString(),
      'last_day': lastDayOfMonth.day.toString(),
      'current_month_text': DateFormat('yyyy년 M월').format(now),
    };

    await updateWidget(widgetData);
  }
}
