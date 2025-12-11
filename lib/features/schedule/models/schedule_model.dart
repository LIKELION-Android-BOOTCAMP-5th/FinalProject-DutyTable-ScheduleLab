class ScheduleModel {
  final int id;
  final int calendarId;
  final String title;
  final String colorValue;
  final DateTime startedAt;
  final DateTime endedAt;
  final String? emotionTag;
  final bool isDone;

  ScheduleModel({
    required this.id,
    required this.calendarId,
    required this.title,
    required this.colorValue,
    required this.startedAt,
    required this.endedAt,
    required this.emotionTag,
    required this.isDone,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      calendarId: json['calendar_id'],
      title: json['title'] ?? "",
      colorValue: json['color_value'] ?? '0xFFE0E0E0',
      startedAt: DateTime.parse(json['started_at']),
      endedAt: DateTime.parse(json['ended_at']),
      emotionTag: json['emotion_tag'],
      isDone: json['is_done'] ?? false,
    );
  }
}
