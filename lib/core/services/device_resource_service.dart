import 'dart:io';

import 'package:image_picker/image_picker.dart';

class DeviceResourceService {
  static final DeviceResourceService _instance =
      DeviceResourceService._internal();
  factory DeviceResourceService() => _instance;
  DeviceResourceService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return null;
    return File(image.path);
  }
}
