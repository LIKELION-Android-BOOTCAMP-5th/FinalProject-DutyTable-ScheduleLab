import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    /// 전체 배경
    scaffoldBackgroundColor: AppColors.backgroundLight,

    /// 카드 배경
    cardColor: AppColors.cardBackgroundLight,

    /// divider, border 계열
    dividerColor: AppColors.cardShadowLight,

    /// 주요 컬러
    primaryColor: AppColors.primaryCalendarTextLight,

    /// 기본 텍스트 테마
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textLight),
    ),

    /// AppBar도 자동 대응
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textLight,
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    /// 전체 배경
    scaffoldBackgroundColor: AppColors.backgroundDark,

    /// 카드 배경
    cardColor: AppColors.cardBackgroundDark,

    /// divider, border 계열
    dividerColor: AppColors.cardShadowDark,

    /// 주요 컬러
    primaryColor: AppColors.primaryCalendarTextDark,

    /// 기본 텍스트 테마
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textDark),
    ),

    /// AppBar도 자동 대응
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textDark,
      elevation: 0,
    ),
  );
}
