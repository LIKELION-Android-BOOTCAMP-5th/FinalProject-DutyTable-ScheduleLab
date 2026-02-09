class ScheduleEntity {
  final int id;
  final int calendarId;
  final String? repeatGroupId;

  final String title;
  final String emotionTag;
  final String colorValue;

  final bool isDone;

  final DateTime startedAt;
  final DateTime endedAt;

  final bool isRepeat;
  final int? repeatNum;
  final String? repeatOption;
  final bool? weekendException;
  final bool? holidayException;
  final int? repeatCount;

  final String? address;
  final String? longitude;
  final String? latitude;

  final String? memo;
  final DateTime createdAt;
  List<Map<String, dynamic>>? schedules;

  ScheduleEntity({
    required this.id,
    required this.calendarId,
    this.repeatGroupId,
    required this.title,
    required this.colorValue,
    required this.isDone,
    required this.startedAt,
    required this.endedAt,
    required this.isRepeat,
    required this.createdAt,
    required this.emotionTag,
    this.repeatNum,
    this.repeatOption,
    this.weekendException,
    this.holidayException,
    this.repeatCount,
    this.address,
    this.longitude,
    this.latitude,
    this.memo,
  });

  ScheduleEntity copyWith({
    int? id,
    int? calendarId,
    String? repeatGroupId,
    String? title,
    String? emotionTag,
    String? colorValue,
    bool? isDone,
    DateTime? startedAt,
    DateTime? endedAt,
    bool? isRepeat,
    int? repeatNum,
    String? repeatOption,
    bool? weekendException,
    bool? holidayException,
    int? repeatCount,
    String? address,
    String? longitude,
    String? latitude,
    String? memo,
    DateTime? createdAt,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      calendarId: calendarId ?? this.calendarId,
      repeatGroupId: repeatGroupId ?? this.repeatGroupId,
      title: title ?? this.title,
      emotionTag: emotionTag ?? this.emotionTag,
      colorValue: colorValue ?? this.colorValue,
      isDone: isDone ?? this.isDone,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      isRepeat: isRepeat ?? this.isRepeat,
      repeatNum: repeatNum ?? this.repeatNum,
      repeatOption: repeatOption ?? this.repeatOption,
      weekendException: weekendException ?? this.weekendException,
      holidayException: holidayException ?? this.holidayException,
      repeatCount: repeatCount ?? this.repeatCount,
      address: address ?? this.address,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
