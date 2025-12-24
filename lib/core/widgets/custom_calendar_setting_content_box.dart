import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCalendarSettingContentBox extends StatelessWidget {
  /// 박스 위에 표시할 내용
  final Widget? title;

  /// 박스 안에 표시할 내용
  final Widget child;

  /// 커스텀 캘린더 설정 컨텐츠 박스
  const CustomCalendarSettingContentBox({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 반환할 위젯 리스트
    List<Widget> childrenList = [];

    // 박스 위에 표시할 내용 없을 경우
    if (title != null) {
      childrenList.add(title!);
      childrenList.add(const SizedBox(height: 8));
    }

    // 박스 위에 표시할 내용 있을 경우
    childrenList.add(
      ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 56.0, // 기본 최소 높이(텍스트 필드랑 동일하게)
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.dBorder : AppColors.lBorder,
              width: 2,
            ),
            color: AppColors.surface(context),
          ),
          child: child,
        ),
      ),
    );

    // 실제 리턴 부분
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: childrenList,
    );
  }
}
