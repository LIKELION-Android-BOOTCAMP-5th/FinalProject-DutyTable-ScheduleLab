import 'package:flutter/material.dart';

class AppColors {
  // 공통 (Common)
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color primaryBlue = Color(0xFF3C82F6);
  static const Color pointBlue = Color(0xFF2663E5);
  static const Color pureDanger = Color(0xFFDC2625);
  static const Color pureSuccess = Color(0xFF4CAF50);
  static const Color inviteBlue = Color(0xFF3C82F6);
  static const Color reminderPurple = Color(0xFFA855F7);

  // 라이트 모드 전용 (Light Mode)
  static const Color lBackground = Color(0xFFFFFFFF);
  static const Color lSurface = Color(0xFFF9FAFB);
  static const Color lTextMain = Color(0xFF030712);
  static const Color lTextSub = Color(0xFF6B7280);
  static const Color lBorder = Color(0xFFD1D5DB);
  static const Color lCalendarYellow = Color(0xFFFEFCE8);
  static const Color lCalendarYellowBorder = Color(0xFFFFEF8A);
  static const Color lDanger = Color(0xFFF25C5C);
  static const Color lIconSub = Color(0xFF545D6A);

  // 다크 모드 전용 (Dark Mode)
  static const Color dBackground = Color(0xFF101827);
  static const Color dSurface = Color(0xFF1F2937);
  static const Color dTextMain = Color(0xFFFFFFFF);
  static const Color dTextSub = Color(0xFF9CA3AF);
  static const Color dBorder = Color(0xFF374151);
  static const Color dNotificationBlue = Color(0xFF5591DC);
  static const Color dWarningBg = Color(0xFF2F2523);
  static const Color dWarningBorder = Color(0xFF85520E);
  static const Color dIconSub = Color(0xFF9CA3AF);

  static Color background(BuildContext context) =>
      _isDark(context) ? dBackground : lBackground;

  static Color surface(BuildContext context) =>
      _isDark(context) ? dSurface : lSurface;

  static Color textMain(BuildContext context) =>
      _isDark(context) ? dTextMain : lTextMain;

  static Color textSub(BuildContext context) =>
      _isDark(context) ? dTextSub : lTextSub;

  static Color primary(BuildContext context) => primaryBlue;

  static Color danger(BuildContext context) =>
      _isDark(context) ? pureDanger : lDanger;

  static Color notificationCard(BuildContext context) =>
      _isDark(context) ? dSurface : lSurface;

  static Color warningBanner(BuildContext context) =>
      _isDark(context) ? dWarningBg : lCalendarYellow;

  static Color warningBannerBorder(BuildContext context) =>
      _isDark(context) ? dWarningBorder : lCalendarYellowBorder;

  static Color calendarText(BuildContext context) =>
      _isDark(context) ? pureWhite : const Color(0xFF141722);

  static Color iconSub(BuildContext context) =>
      _isDark(context) ? dIconSub : lIconSub;

  static Color notificationCardBg(
    BuildContext context, {
    required String type,
    required bool isRead,
  }) {
    return type == "invite"
        ? isRead
              ? inviteBlue.withOpacity(0.6)
              : inviteBlue
        : isRead
        ? reminderPurple.withOpacity(0.6)
        : reminderPurple;
  }

  static Color notificationCardPoint(
    BuildContext context, {
    required String type,
    required bool isRead,
  }) {
    if (type == "invite") {
      if (isRead) return surface(context);
      return inviteBlue;
    } else {
      if (isRead) return surface(context);
      return reminderPurple;
    }
  }

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
