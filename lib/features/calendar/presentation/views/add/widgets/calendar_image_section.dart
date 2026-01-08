import 'package:dutytable/core/configs/app_colors.dart';
import 'package:dutytable/features/calendar/presentation/viewmodels/calendar_add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/utils/image_picker_utils.dart';

class CalendarImageSection extends StatelessWidget {
  /// 캘린더 이미지
  const CalendarImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<CalendarAddViewModel>();

    return Column(
      children: [
        /// 캘린더 이미지 제목
        Text(
          "캘린더 사진",
          style: TextStyle(
            color: AppColors.textMain(context),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        /// 이미지 추가 및 이미지 추가된 이미지 보여주기
        GestureDetector(
          onTap: () async {
            ImagePickerUtils.showImagePicker(
              context: context,
              onImageSelected: (source) => viewModel.pickCalendarImage(source),
              onDelete: viewModel.deleteImage,
            );
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDarkMode ? AppColors.dBorder : AppColors.lBorder,
                width: 2,
              ),
              color: AppColors.surface(context),
            ),
            child: viewModel.imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.file(viewModel.imageFile!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.textSub(context),
                      size: 36,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 8),

        /// 캘린더 이미지 설명
        Text(
          "사진을 입력해주세요",
          style: TextStyle(
            color: AppColors.textSub(context),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
