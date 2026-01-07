import 'package:flutter/material.dart';

import '../../../../core/configs/app_colors.dart';

class LabeledTextField extends StatelessWidget {
  /// 라벨
  final String label;

  /// 최대 텍스트 라인 - 기본 1
  final int maxLines;

  /// 텍스트 필드 힌트
  final String? hint;

  /// TODO: 추후 ViewModel로 이동 시 삭제
  /// 텍스트 에딧 컨트롤
  final TextEditingController? controller;

  /// 텍스트 필드 validation
  final String? Function(String?)? validator;

  /// 읽기 전용 체크 - 멤버 추가 다이얼로그
  final bool readOnly;

  /// 텍스트 필드 클릭 시 해당 콜백 함수
  final VoidCallback? onTap;

  final ValueChanged<String>? onChanged;

  final int? maxLength;

  /// 라벨 + 텍스트 필드
  const LabeledTextField({
    super.key,
    required this.label,
    this.maxLines = 1,
    this.controller,
    this.hint,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textMain(context),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: TextStyle(color: AppColors.textMain(context)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textSub(context),
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: AppColors.surface(context),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.textSub(context),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
