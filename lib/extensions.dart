import 'dart:ui';

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
    return DateTime.parse(this);
  }
}

extension HexColorExtension on String {
  /// 문자열을 ARGB int 값으로 변환하여 Color 객체를 반환합니다.
  ///
  /// - '0x' 접두사나 '#' 접두사가 있다면 제거합니다.
  /// - 길이가 6자리(RRGGBB)면 불투명도(FF)를 추가합니다.
  /// - 변환 실패 시 기본값 (0xFFE0E0E0)을 반환합니다.
  Color toColor() {
    String cleanString = this;

    // 1. 0x 또는 # 접두사 제거 (DB에 0x, 웹에서는 #을 많이 사용)
    if (cleanString.startsWith('0x') || cleanString.startsWith('0X')) {
      cleanString = cleanString.substring(2);
    } else if (cleanString.startsWith('#')) {
      cleanString = cleanString.substring(1);
    }

    // 2. 길이가 6(RGB)이면 FF (불투명) 추가
    // 이 로직은 필수적입니다. Flutter Color 생성자는 32비트 ARGB를 요구합니다.
    if (cleanString.length == 6) {
      cleanString = 'FF$cleanString';
    }

    // 3. 16진수 파싱 (tryParse를 사용하여 오류 방지 및 기본값 제공)
    // 파싱 실패 또는 문자열이 비어있을 경우 0xFFE0E0E0 (연한 회색) 반환
    final int parsedColorInt =
        int.tryParse(cleanString, radix: 16) ?? 0xFFE0E0E0;

    // 4. Color 객체 반환
    return Color(parsedColorInt);
  }
}
