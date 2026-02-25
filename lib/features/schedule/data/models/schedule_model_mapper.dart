import 'package:dutytable/features/schedule/data/models/schedule_model.dart';
import 'package:dutytable/features/schedule/domain/entities/schedule_entity.dart';

extension ScheduleModelMapper on ScheduleModel {
  ScheduleEntity toEntity() {
    return ScheduleEntity(
      id: id,
      calendarId: calendarId,
      repeatGroupId: repeatGroupId,
      title: title,
      emotionTag: emotionTag,
      colorValue: colorValue,
      isDone: isDone,
      startedAt: startedAt,
      endedAt: endedAt,
      isRepeat: isRepeat,
      repeatNum: repeatNum,
      repeatOption: repeatOption,
      weekendException: weekendException,
      holidayException: holidayException,
      repeatCount: repeatCount,
      excludedDates: excludedDates,
      address: address,
      longitude: longitude,
      latitude: latitude,
      memo: memo,
      createdAt: createdAt,
    );
  }
}

extension ScheduleEntityMapper on ScheduleEntity {
  ScheduleModel toModel() {
    return ScheduleModel(
      id: id,
      calendarId: calendarId,
      repeatGroupId: repeatGroupId,
      title: title,
      emotionTag: emotionTag,
      colorValue: colorValue,
      isDone: isDone,
      startedAt: startedAt,
      endedAt: endedAt,
      isRepeat: isRepeat,
      repeatNum: repeatNum,
      repeatOption: repeatOption,
      weekendException: weekendException,
      holidayException: holidayException,
      repeatCount: repeatCount,
      excludedDates: excludedDates,
      address: address,
      longitude: longitude,
      latitude: latitude,
      memo: memo,
      createdAt: createdAt,
    );
  }
}
