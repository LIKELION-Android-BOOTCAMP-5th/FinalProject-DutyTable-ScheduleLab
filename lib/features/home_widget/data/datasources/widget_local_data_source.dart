import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../../calendar/data/datasources/calendar_data_source.dart';
import '../../../schedule/data/datasources/schedule_data_source.dart';
import '../../../schedule/data/models/schedule_model.dart';

abstract class WidgetDataSource {
  Future<void> updateWidget(Map<String, String> data);
  Future<void> updateCalendarWidget(List<ScheduleModel> schedules);
}

class WidgetDataSourceImpl implements WidgetDataSource {
  static const String appGroupId = 'group.com.schedulelab.dutytable';
  static const String iosWidgetName = 'MyWidgetExtension';
  static const String androidWidgetName = 'MyWidgetExtension';

  @override
  Future<void> updateWidget(Map<String, String> data) async {
    await HomeWidget.setAppGroupId(appGroupId);

    for (var entry in data.entries) {
      // 명시적으로 String 저장 확인
      bool? success = await HomeWidget.saveWidgetData<String>(
        entry.key,
        entry.value,
      );
    }

    await HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      androidName: androidWidgetName,
    );
  }

  @override
  Future<void> updateCalendarWidget(List<ScheduleModel> schedules) async {
    final now = DateTime.now();

    // 1. 날짜 정보 계산
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final firstDayOffset = firstDayOfMonth.weekday % 7;

    // 2. 날짜별 일정 가공 (날짜: "제목|색상")
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

    // 3. 오늘과 내일의 일정 요약 (소형/중형 위젯용)
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final tomorrowStr = DateFormat(
      'yyyy-MM-dd',
    ).format(now.add(const Duration(days: 1)));

    String getDutiesForDate(String dateStr) {
      return schedules
          .where((s) => DateFormat('yyyy-MM-dd').format(s.startedAt) == dateStr)
          .map((e) => e.title)
          .join(', ');
    }

    // 4. 최종 위젯 데이터 맵 구성
    final Map<String, String> widgetData = {
      'date_key': DateFormat('M월 d일 (E)', 'ko_KR').format(now),
      'today_duties':
          getDutiesForDate(DateFormat('yyyy-MM-dd').format(now)).isEmpty
          ? "일정 없음"
          : getDutiesForDate(DateFormat('yyyy-MM-dd').format(now)),

      'tomorrow_date': DateFormat(
        'M월 d일 (E)',
        'ko_KR',
      ).format(now.add(const Duration(days: 1))),
      'tomorrow_duties':
          getDutiesForDate(
            DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1))),
          ).isEmpty
          ? "일정 없음"
          : getDutiesForDate(
              DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1))),
            ),

      'calendar_json': jsonEncode(calendarMap),
      'first_day_offset': firstDayOffset.toString().trim(),
      'last_day': lastDayOfMonth.day.toString(),
      'current_month_text': DateFormat('yyyy년 M월').format(now),
    };

    // 저장 및 업데이트 실행
    await updateWidget(widgetData);
  }
}

extension WidgetUpdateExtension on WidgetDataSourceImpl {
  /// 현재 달의 일정만 가져와 위젯 업데이트
  Future<void> syncAllCalendarsToWidget() async {
    try {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      List<ScheduleModel> allSchedules = [];

      // 1. 개인 캘린더 일정 (기간 한정)
      final personalCalendar = await CalendarDataSource.instance
          .fetchPersonalCalendar();
      final personalSchedules = await ScheduleDataSource.instance
          .fetchSchedulesByRange(
            calendarId: personalCalendar.id,
            from: firstDay,
            to: lastDay,
          );
      allSchedules.addAll(personalSchedules);

      // 2. 공유 캘린더 리스트 가져오기
      final sharedCalendars = await CalendarDataSource.instance
          .fetchCalendarFinalList('group');

      // 3. 각 공유 캘린더의 일정을 병렬로 범위 조회
      final groupScheduleFutures = sharedCalendars.map(
        (c) => ScheduleDataSource.instance.fetchSchedulesByRange(
          calendarId: c.id,
          from: firstDay,
          to: lastDay,
        ),
      );
      final List<List<ScheduleModel>> groupSchedulesList = await Future.wait(
        groupScheduleFutures,
      );

      for (var schedules in groupSchedulesList) {
        allSchedules.addAll(schedules);
      }

      // 4. 내 일정(개인) 동기화 (기간 한정)
      final mySchedules = await ScheduleDataSource.instance.fetchMySchedules(
        from: firstDay,
        to: lastDay,
      );
      allSchedules.addAll(mySchedules);

      // 5. 중복 제거 및 위젯 전송
      final distinctSchedules = {
        for (var s in allSchedules) s.id: s,
      }.values.toList();
      await updateCalendarWidget(distinctSchedules);

      debugPrint(
        "🚀 위젯 쿼리 최적화 완료 (${now.month}월 일정: ${distinctSchedules.length}개)",
      );
    } catch (e) {
      debugPrint("❌ 위젯 최적화 동기화 에러: $e");
    }
  }
}
