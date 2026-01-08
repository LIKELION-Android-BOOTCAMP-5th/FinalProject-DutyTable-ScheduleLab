import 'dart:io';

import 'package:dutytable/core/configs/app_colors.dart';
import 'package:flutter/material.dart';

class SignupProfileImagePicker extends StatelessWidget {
  final File? selectedImage;
  final void Function() onPickImage;

  const SignupProfileImagePicker({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ImageProvider? imageProvider;
    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!);
    }

    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isDark ? AppColors.dBorder : AppColors.lBorder,
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.surface(context),
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Icon(Icons.photo, size: 40, color: AppColors.iconSub(context))
                : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: AppColors.background(context),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.dBorder : AppColors.lBorder,
                width: 2,
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.camera_alt,
                color: AppColors.iconSub(context),
                size: 20,
              ),
              onPressed: () {
                onPickImage();
              },
            ),
          ),
        ),
      ],
    );
  }
}
