/// AI에 의해 감지된 일정 정보
class DetectedSchedule {
  /// 일정 제목 (빈 문자열 가능)
  final String title;

  /// 일정 날짜 ("YYYY-MM-DD" 형식)
  final String date;

  /// 일정 시간 ("HH:mm" 형식)
  final String time;

  /// 일정 장소 (null 가능)
  final String? place;

  DetectedSchedule({
    required this.title,
    required this.date,
    required this.time,
    this.place,
  });

  factory DetectedSchedule.fromJson(Map<String, dynamic> json) {
    return DetectedSchedule(
      title: json['title'] as String? ?? '',
      date: json['date'] as String,
      time: json['time'] as String,
      place: json['place'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date,
    'time': time,
    'place': place,
  };

  /// 일부 필드를 업데이트하여 새 인스턴스 반환
  DetectedSchedule copyWith({
    String? title,
    String? date,
    String? time,
    String? place,
  }) {
    return DetectedSchedule(
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      place: place ?? this.place,
    );
  }
}
