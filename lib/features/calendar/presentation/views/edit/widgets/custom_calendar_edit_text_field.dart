import 'package:flutter/material.dart';

class CustomCalendarEditTextField extends StatelessWidget {
  /// 박스 위에 표시할 내용
  final Widget title;
  final TextEditingController controller;

  /// 커스텀 캘린더 수정 텍스트 필드
  const CustomCalendarEditTextField({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 8),
        TextField(
          minLines: 1,
          maxLines: null, // 높이 제한 없음
          controller: controller,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0x61000000)),
            ),
          ),
        ),
      ],
    );
  }
}
