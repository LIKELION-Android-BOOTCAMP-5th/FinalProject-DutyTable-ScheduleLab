class ScheduleModel {
  final int id;
  final int calendarId;
  final String? repeatGroupId; // ✅ 추가: 반복 일정을 묶어주는 고유 ID

  final String title;
  final String? emotionTag;
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

  const ScheduleModel({
    required this.id,
    required this.calendarId,
    this.repeatGroupId, // ✅ 추가
    required this.title,
    required this.colorValue,
    required this.isDone,
    required this.startedAt,
    required this.endedAt,
    required this.isRepeat,
    required this.createdAt,
    this.emotionTag,
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

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as int,
      calendarId: json['calendar_id'] as int,
      repeatGroupId: json['repeat_group_id'] as String?, // ✅ 추가
      title: json['title'] as String,
      emotionTag: json['emotion_tag'] as String?,
      colorValue: json['color_value'] as String,
      isDone: json['is_done'] as bool,
      startedAt: DateTime.parse(json['started_at']).toLocal(),
      endedAt: DateTime.parse(json['ended_at']).toLocal(),
      isRepeat: json['is_repeat'] as bool,
      repeatNum: json['repeat_num'] as int?,
      repeatOption: json['repeat_option'] as String?,
      weekendException: json['weekend_exception'] as bool?,
      holidayException: json['holiday_exception'] as bool?,
      // ✅ 수정: int?로 처리하거나 null일 경우 1로 기본값 설정 (에러 방지)
      repeatCount: json['repeat_count'] as int?,
      address: json['address'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calendar_id': calendarId,
      'repeat_group_id': repeatGroupId, // ✅ 추가
      'title': title,
      'emotion_tag': emotionTag,
      'color_value': colorValue,
      'is_done': isDone,
      'started_at': startedAt.toUtc().toIso8601String(),
      'ended_at': endedAt.toUtc().toIso8601String(),
      'is_repeat': isRepeat,
      'repeat_num': repeatNum,
      'repeat_option': repeatOption,
      'weekend_exception': weekendException,
      'holiday_exception': holidayException,
      'repeat_count': repeatCount,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'memo': memo,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  ScheduleModel copyWith({
    String? title,
    String? colorValue,
    bool? isDone,
    bool? isRepeat,
    String? repeatOption,
    int? repeatNum,
    bool? weekendException,
    bool? holidayException,
    int? repeatCount,
    String? memo,
    String? repeatGroupId, // ✅ 추가
  }) {
    return ScheduleModel(
      id: id,
      calendarId: calendarId,
      repeatGroupId: repeatGroupId ?? this.repeatGroupId, // ✅ 추가
      title: title ?? this.title,
      colorValue: colorValue ?? this.colorValue,
      emotionTag: emotionTag,
      isDone: isDone ?? this.isDone,
      startedAt: startedAt,
      endedAt: endedAt,
      isRepeat: isRepeat ?? this.isRepeat,
      repeatNum: repeatNum ?? this.repeatNum,
      repeatOption: repeatOption ?? this.repeatOption,
      weekendException: weekendException ?? this.weekendException,
      holidayException: holidayException ?? this.holidayException,
      repeatCount: repeatCount ?? this.repeatCount,
      address: address,
      longitude: longitude,
      latitude: latitude,
      memo: memo ?? this.memo,
      createdAt: createdAt,
    );
  }
}
