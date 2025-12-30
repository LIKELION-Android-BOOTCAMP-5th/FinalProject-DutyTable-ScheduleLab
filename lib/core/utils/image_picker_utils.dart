// core/utils/image_picker_utils.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtils {
  static void showImagePicker({
    required BuildContext context,
    required Function(ImageSource source) onImageSelected,
    VoidCallback? onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("사진 촬영"),
              onTap: () {
                context.pop(context);
                onImageSelected(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("앨범에서 선택"),
              onTap: () {
                context.pop(context);
                onImageSelected(ImageSource.gallery);
              },
            ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.no_photography_outlined),
                title: const Text("이미지 삭제"),
                onTap: () {
                  context.pop(context);
                  onDelete();
                },
              ),
          ],
        ),
      ),
    );
  }
}
