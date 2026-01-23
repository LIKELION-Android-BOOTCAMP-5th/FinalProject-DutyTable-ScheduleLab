import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../calendar/domain/repositories/calendar_repository.dart';
import '../../../schedule/domain/repositories/schedule_repository.dart';
import '../../domain/repositories/widget_repository.dart';
import '../datasources/widget_local_data_source.dart';

@LazySingleton(as: WidgetRepository)
class WidgetRepositoryImpl implements WidgetRepository {
  final WidgetLocalDataSource _widgetDataSource;
  final ScheduleRepository _scheduleRepository;
  final CalendarRepository _calendarRepository;

  WidgetRepositoryImpl(
    this._widgetDataSource,
    this._scheduleRepository,
    this._calendarRepository,
  );

  @override
  Future<void> syncAllCalendarsToWidget() async {
    try {
      final now = DateTime.now();
      final firstDay = DateTime(now.year, now.month, 1);
      final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      // 1. 모든 일정 데이터를 담을 리스트 (Entity 사용)
      List<ScheduleEntity> allSchedules = [];

      // 2. 개인 캘린더 일정 가져오기
      final personalCalendar = await _calendarRepository.readPersonalCalendar();
      final personalSchedules = await _scheduleRepository.fetchSchedulesByRange(
        calendarId: personalCalendar.id,
        from: firstDay,
        to: lastDay,
      );
      allSchedules.addAll(personalSchedules);

      // 3. 공유 캘린더들 가져오기
      final sharedCalendars = await _calendarRepository.readCalendarFinalList(
        'group',
      );

      // 4. 각 캘린더의 일정 병렬 조회
      final results = await Future.wait(
        sharedCalendars.map(
          (c) => _scheduleRepository.fetchSchedulesByRange(
            calendarId: c.id,
            from: firstDay,
            to: lastDay,
          ),
        ),
      );
      for (var schedules in results) {
        allSchedules.addAll(schedules);
      }

      // 5. 중복 제거 (ID 기준)
      final distinctSchedules = {
        for (var s in allSchedules) s.id: s,
      }.values.toList();

      // 6. DataSource에 전달 (여기서 Model로 캐스팅하거나 DataSource가 Entity를 받도록 설계)
      await _widgetDataSource.updateCalendarWidget(
        distinctSchedules.cast<ScheduleEntity>(),
      );
    } catch (e) {
      debugPrint("❌ Widget Sync Error: $e");
    }
  }
}
