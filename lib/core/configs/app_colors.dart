import 'package:flutter/material.dart';

class AppColors {
  static const Color commonBlue = Color(0xFF4982f6);
  static const Color commonWhite = Color(0xFFFFFFFF);
  static const Color commonRed = Color(0xFFEE4444);
  static const Color commonGrey = Color(0xFF9E9E9E);
  static const Color commonBlack54 = Colors.black54;
  static const Color commonGreyShade400 = Color(0xffBDBDBD);

  // --- 라이트 모드 색상 ---
  static const Color primaryCalendarTopLight = Color(0xFFDBE9FE);
  static const Color primaryListTopLight = Color(0xFFF3E8FF);
  static const Color primaryChatTopLight = Color(0xFFFBE7F3);

  static const Color primaryCalendarTextLight = Color(0xFF3F76EE);
  static const Color primaryListTextLight = Color(0xFF9E49ED);
  static const Color primaryChatTextLight = Color(0xFFDE357F);

  static const Color bottomBarPointLight = Color(0xFFEF4444);
  static const Color bottomBarIconDefaultLight = Color(0xFFD1D5DB);

  static const Color textLight = Color(0xFF000000);
  static const Color subTextLight = Color(0xFF9E9E9E);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color boxShadowLight = Color(0x1F000000);

  static const Color cardBackgroundLight = Color(0xFFFFFFFF);
  static const Color cardShadowLight = Color(0xFFF7F8F9);
  static const Color cardBorderLight = Color(0xFFF3F4F6);

  static const Color cardChipLight = Color(0xFFF3F4F6);
  static const Color cardChipTextLight = Color(0xFF5f6774);

  static const Color chatMyMessageLight = Color(0xFF3C82F6);
  static const Color chatOtherMessageLight = Color(0xFFF7F8F9);

  static const Color actionPositiveLight = Color(0xFF3C82F6);
  static const Color actionNegativeExitLight = Color(0xFFED4343);

  // --- 다크 모드 색상 ---
  static const Color primaryCalendarTopDark = Color(0xFF253B5E);
  static const Color primaryListTopDark = Color(0xFF3B335E);
  static const Color primaryChatTopDark = Color(0xFF4A314B);

  static const Color primaryCalendarTextDark = Color(0xFF5088CF);
  static const Color primaryListTextDark = Color(0xFF9D6ED2);
  static const Color primaryChatTextDark = Color(0xFFD666A4);

  static const Color bottomBarPointDark = Color(0xFFEF4444);
  static const Color bottomBarIconDefaultDark = Color(0xFF374151);

  static const Color textDark = Color(0xFFFFFFFF);
  static const Color subTextDark = Color(0xFFFFFFB3);
  static const Color backgroundDark = Color(0xFF101827);
  static const Color boxShadowDark = Color(0x73000000);

  static const Color cardBackgroundDark = Color(0xFF374151);
  static const Color cardShadowDark = Color(0xFF1F2937);
  static const Color cardBorderDark = Color(0xFF4b5563);

  static const Color cardChipDark = Color(0xFF4C5462);
  static const Color cardChipTextDark = Color(0xFF8E94A1);

  static const Color chatMyMessageDark = Color(0xFF2463EB);
  static const Color chatOtherMessageDark = Color(0xFF303945);

  static const Color actionPositiveDark = Color(0xFF3C82F6);
  static const Color actionNegativeExitDark = Color(0xFFDB2625);

  /// 현재 테마에 맞는 배경
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? backgroundDark
        : backgroundLight;
  }

  /// 현재 테마에 맞는 텍스트
  static Color text(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? textDark
        : textLight;
  }

  /// 현재 테마에 맞는 서브 텍스트
  static Color subText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? subTextDark
        : subTextLight;
  }

  /// 현재 테마에 맞는 박스 그림자
  static Color boxShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? boxShadowDark
        : boxShadowLight;
  }

  /// 현재 테마에 맞는 카드 배경
  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardBackgroundDark
        : cardBackgroundLight;
  }

  /// 현재 테마에 맞는 카드 그림자
  static Color cardShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardShadowDark
        : cardShadowLight;
  }

  /// 현재 태머애 멎는 카드 테두리
  static Color cardBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardBorderDark
        : cardBorderLight;
  }

  /// 현재 테마에 맞는 카드 선택 불가 배경색
  static Color cardBlur(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black26
        : Colors.white60;
  }

  /// 현재 테마에 맞는 버튼 색(positive)
  static Color actionPositive(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? actionPositiveDark
        : actionPositiveLight;
  }

  /// 현재 테마에 맞는 버튼 색(negative)
  static Color actionNegative(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? actionNegativeExitDark
        : actionNegativeExitLight;
  }

  /// 현재 테마에 맞는 칩 색
  static Color chip(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardChipDark
        : cardChipLight;
  }

  /// 현재 테마에 맞는 칩 텍스트 색
  static Color chipText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? cardChipTextDark
        : cardChipTextLight;
  }
}
