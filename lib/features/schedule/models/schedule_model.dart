class ScheduleModel {
  final int id;
  final int calendarId;

  final String title;
  final String? emotionTag;
  final String colorValue;

  final bool isDone;

  /// ISO String (timestamptz)
  final DateTime startedAt;
  final DateTime endedAt;

  /// 반복
  final bool isRepeat;
  final int? repeatNum;
  final String? repeatOption; // day, week, month, year
  final int? repeatCount;
  final bool? weekendException;
  final bool? holidayException;

  /// 위치
  final String? address;
  final String? longitude;
  final String? latitude;

  /// 메모
  final String? memo;

  final DateTime createdAt;

  const ScheduleModel({
    required this.id,
    required this.calendarId,
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
    this.repeatCount,
    this.weekendException,
    this.holidayException,
    this.address,
    this.longitude,
    this.latitude,
    this.memo,
  });

  // ----------------------------
  // fromJson
  // ----------------------------
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as int,
      calendarId: json['calendar_id'] as int,
      title: json['title'] as String,
      emotionTag: json['emotion_tag'] as String?,
      colorValue: json['color_value'] as String,
      isDone: json['is_done'] as bool,
      startedAt: DateTime.parse(json['started_at']).toLocal(),
      endedAt: DateTime.parse(json['ended_at']).toLocal(),
      isRepeat: json['is_repeat'] as bool,
      repeatNum: json['repeat_num'] as int?,
      repeatOption: json['repeat_option'] as String?,
      repeatCount: json['repeat_count'] as int?,
      weekendException: json['weekend_exception'] as bool?,
      holidayException: json['holiday_exception'] as bool?,
      address: json['address'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  // ----------------------------
  // toJson (update / insert 용)
  // ----------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calendar_id': calendarId,
      'title': title,
      'emotion_tag': emotionTag,
      'color_value': colorValue,
      'is_done': isDone,
      'started_at': startedAt.toUtc().toIso8601String(),
      'ended_at': endedAt.toUtc().toIso8601String(),
      'is_repeat': isRepeat,
      'repeat_num': repeatNum,
      'repeat_option': repeatOption,
      'repeat_count': repeatCount,
      'weekend_exception': weekendException,
      'holiday_exception': holidayException,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'memo': memo,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  // ----------------------------
  // copyWith (편집 화면 필수)
  // ----------------------------
  ScheduleModel copyWith({
    bool? isDone,
    bool? isRepeat,
    String? repeatOption,
    int? repeatCount,
    bool? weekendException,
    bool? holidayException,
    String? memo,
  }) {
    return ScheduleModel(
      id: id,
      calendarId: calendarId,
      title: title,
      colorValue: colorValue,
      emotionTag: emotionTag,
      isDone: isDone ?? this.isDone,
      startedAt: startedAt,
      endedAt: endedAt,
      isRepeat: isRepeat ?? this.isRepeat,
      repeatNum: repeatNum,
      repeatOption: repeatOption ?? this.repeatOption,
      repeatCount: repeatCount ?? this.repeatCount,
      weekendException: weekendException ?? this.weekendException,
      holidayException: holidayException ?? this.holidayException,
      address: address,
      longitude: longitude,
      latitude: latitude,
      memo: memo ?? this.memo,
      createdAt: createdAt,
    );
  }
}
