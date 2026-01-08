import 'package:dutytable/features/schedule/data/models/schedule_model.dart';

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
    final start = onlyDate(startedAt);
    final end = onlyDate(endedAt);

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

/// 채팅 시간 함수
extension ChattingDateTime on String {
  String toChatTime() {
    // 1. UTC 문자열을 파싱한 후, 시스템 로컬 시간대(KST)로 변환합니다.
    final createdAtLocal = DateTime.parse(this).toLocal();

    // 2. 오전/오후 구분
    String amPm = createdAtLocal.hour < 12 ? '오전' : '오후';

    // 3. 12시간제 시간 계산 (0시와 12시를 12로 표시)
    int hour12 = createdAtLocal.hour % 12;
    if (hour12 == 0) hour12 = 12;

    // 4. 분(minute)은 padLeft를 사용하여 항상 두 자릿수로 표시
    String minute = createdAtLocal.minute.toString().padLeft(2, '0');

    return '$amPm $hour12시 $minute분';
  }
}

/// 반복 일정 계산 관련 확장
extension ScheduleRepeatExtension on DateTime {
  /// 현재 날짜가 예외(주말/공휴일)인지 체크합니다.
  bool checkIsException({
    required List<DateTime> holidays,
    required bool weekendException,
    required bool holidayException,
  }) {
    bool isWeekend = weekday == DateTime.saturday || weekday == DateTime.sunday;
    bool isHoliday = holidays.any(
      (h) => h.year == year && h.month == month && h.day == day,
    );

    return (weekendException && isWeekend) || (holidayException && isHoliday);
  }

  /// 다음 반복 날짜를 계산하여 반환합니다.
  DateTime jumpToNextWorkingDay({
    required String repeatOption,
    required int repeatNum,
    required List<DateTime> holidays,
    required bool weekendException,
    required bool holidayException,
  }) {
    DateTime nextDate = this;

    if (repeatOption == 'daily') {
      // 일 단위: 순수 영업일 수만큼 카운트하며 전진
      int targetJump = repeatNum;
      while (targetJump > 0) {
        nextDate = nextDate.add(const Duration(days: 1));
        // 자기 자신의 checkIsException을 활용
        if (!nextDate.checkIsException(
          holidays: holidays,
          weekendException: weekendException,
          holidayException: holidayException,
        )) {
          targetJump--;
        }
      }
    } else if (repeatOption == 'weekly') {
      // 주 단위: 단순 7일 점프 (요일 유지)
      nextDate = nextDate.add(Duration(days: repeatNum * 7));
    } else if (repeatOption == 'monthly') {
      // 월 단위: 한 달 뒤 점프
      nextDate = DateTime(
        nextDate.year,
        nextDate.month + repeatNum,
        nextDate.day,
      );
    } else if (repeatOption == 'yearly') {
      // 년 단위: 일 년 뒤 점프
      nextDate = DateTime(
        nextDate.year + repeatNum,
        nextDate.month,
        nextDate.day,
      );
    } else {
      nextDate = nextDate.add(Duration(days: repeatNum));
    }

    return nextDate;
  }
}
