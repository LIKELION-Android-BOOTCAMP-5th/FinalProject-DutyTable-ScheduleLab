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
}
