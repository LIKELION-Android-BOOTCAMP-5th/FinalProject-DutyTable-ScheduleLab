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
  Color toColor() {
    String cleanString = this;

    if (cleanString.startsWith('0x') || cleanString.startsWith('0X')) {
      cleanString = cleanString.substring(2);
    } else if (cleanString.startsWith('#')) {
      cleanString = cleanString.substring(1);
    }

    if (cleanString.length == 6) {
      cleanString = 'FF$cleanString';
    }

    final int parsedColorInt =
        int.tryParse(cleanString, radix: 16) ?? 0xFFE0E0E0;

    return Color(parsedColorInt);
  }
}
