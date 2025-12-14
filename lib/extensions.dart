import 'features/schedule/models/schedule_model.dart';

extension NullableStringDateExtensions on String? {
  DateTime? toDateTimeOrNull() {
    if (this == null || this!.isEmpty) {
      return null;
    }

    return DateTime.tryParse(this!);
  }

  DateTime? toDateOnlyDateTimeOrNull() {
    final DateTime? originalDateTime = toDateTimeOrNull();

    if (originalDateTime == null) {
      return null;
    }

    return DateTime(
      originalDateTime.year,
      originalDateTime.month,
      originalDateTime.day,
    );
  }
}

extension NullableDateTimeExtensions on DateTime? {
  /// DateTime? 객체의 시간 정보를 제거하고 (년-월-일)만 남깁니다.
  ///
  /// 입력이 null인 경우 null을 반환합니다.
  /// 아니면 toPureDate()를 호출하여 시간 정보(시/분/초)가 00:00:00으로 설정된
  /// 새로운 DateTime 객체를 반환합니다.
  DateTime? toPureDateOrNull() {
    if (this == null) {
      return null;
    }
    // Non-nullable DateTime 확장을 호출합니다.
    return this!.toPureDate();
  }
}

extension NonNullableDateTimeExtensions on DateTime {
  /// DateTime 객체의 시간 정보를 제거하고 (년-월-일)만 남깁니다.
  ///
  /// 반환된 DateTime 객체의 시간은 항상 자정(00:00:00.000)입니다.
  DateTime toPureDate() {
    return DateTime(year, month, day);
  }
}

extension DateTimeTimeAgoExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 1) return "방금 전";
    if (diff.inMinutes < 60) return "${diff.inMinutes}분 전";
    if (diff.inHours < 24) return "${diff.inHours}시간 전";
    if (diff.inDays < 7) return "${diff.inDays}일 전";

    return "${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }
}

extension StringToDateTime on String {
  // "2022-10-23T00:00:00".toDateTime()
  DateTime toDateTime() {
    return DateTime.parse(this).toLocal();
  }
}

/// 캘린더 탭 - 캘린더 관련 extension
bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

extension ScheduleRangeCheck on ScheduleModel {
  bool containsDay(DateTime day) {
    final d = onlyDate(day);
    final start = onlyDate(startedAt!);
    final end = onlyDate(endedAt!);

    if (start.isAfter(end)) return false;

    return sameDay(d, start) ||
        sameDay(d, end) ||
        (d.isAfter(start) && d.isBefore(end));
  }
}

/// 일정 더보기 - 텍스트로 주말 표현
extension WeekdayExtension on int {
  String get koreanWeekday {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

    if (this < 1 || this > 7) {
      throw RangeError('weekday must be between 1 and 7');
    }

    return weekdays[this - 1];
  }
}

/// 일정 상세 화면 - 시작일 ~ 종료일/n시작 시간 -> 종료 시간
/// 날짜 포멧
extension DateTimeKoreanDate on DateTime {
  String get koreanShortDateWithWeekday {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    return '$month월 $day일 (${weekdays[weekday - 1]})';
  }
}

/// 시간 포멧
extension DateTimeKoreanAmPm on DateTime {
  String get koreanAmPmTime {
    final isAm = hour < 12;
    final period = isAm ? '오전' : '오후';

    final h = hour % 12 == 0 ? 12 : hour % 12;
    final m = minute.toString().padLeft(2, '0');

    return '$period $h:$m';
  }
}

/// supabase storage path 헬퍼 함수
String? extractStoragePath(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) return null;

  final uri = Uri.parse(imageUrl);
  final segments = uri.pathSegments;

  // storage/v1/object/public/{bucket}/{path...}
  final index = segments.indexOf('public');
  if (index == -1 || index + 2 >= segments.length) return null;

  return segments.sublist(index + 2).join('/');
}
