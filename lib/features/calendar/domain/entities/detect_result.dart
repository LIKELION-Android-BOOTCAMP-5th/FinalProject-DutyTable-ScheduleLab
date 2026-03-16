import 'detected_schedule.dart';

/// 일정 감지 결과를 나타내는 sealed class
sealed class DetectResult {}

/// 날짜+시간 포함 일정이 감지된 경우
class ScheduleDetected extends DetectResult {
  final DetectedSchedule schedule;

  ScheduleDetected(this.schedule);
}

/// 장소만 감지된 경우 (날짜, 시간 없음)
class PlaceOnlyDetected extends DetectResult {
  final String place;

  PlaceOnlyDetected(this.place);
}
