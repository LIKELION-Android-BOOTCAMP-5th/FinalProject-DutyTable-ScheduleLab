import 'dart:io';

import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCalendarImageBox extends StatelessWidget {
  final String? imageUrl;

  const CustomCalendarImageBox({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface(context),
        border: Border.all(
          color: AppColors.textSub(context).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    // 이미지가 없는 경우 (기본 로고)
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipOval(
        child: Image.asset(
          "assets/images/calendar_logo.png",
          fit: BoxFit.cover,
        ),
      );
    }

    // 로컬 파일인 경우 (ImagePicker로 방금 선택한 이미지)
    if (!imageUrl!.startsWith('http')) {
      return ClipOval(child: Image.file(File(imageUrl!), fit: BoxFit.cover));
    }

    // 서버에 저장된 네트워크 이미지인 경우
    return ClipOval(
      child: Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // 네트워크 에러 시 기본 이미지 출력
          return Image.asset(
            "assets/images/calendar_logo.png",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
