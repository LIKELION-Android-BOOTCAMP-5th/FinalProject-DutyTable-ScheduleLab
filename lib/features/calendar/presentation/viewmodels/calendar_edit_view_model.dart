import 'dart:io';

import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';

class CalendarEditViewModel extends ChangeNotifier {
  /// 캘린더 제목 컨트롤러(private)
  late final TextEditingController _titleController = TextEditingController(
    text: _calendar.title,
  );

  /// 캘린더 제목 컨트롤러(public)
  TextEditingController get titleController => _titleController;

  /// 캘린더 설명 컨트롤러(private)
  late final TextEditingController _descController = TextEditingController(
    text: _calendar.description,
  );

  /// 캘린더 설명 컨트롤러(public)
  TextEditingController get descController => _descController;

  /// 캘린더 데이터(private)
  late final CalendarModel _initialCalendar; // 초기 데이터 값
  late CalendarModel _calendar;

  /// 캘린더 데이터(public)
  CalendarModel get initialCalendar => _initialCalendar; // 초기 데이터 값
  CalendarModel get calendar => _calendar;

  // 이미지 피커로 갤러리에서 사진 가져오기
  File? _newImage;
  File? get newImage => _newImage;
  final ImagePicker picker = ImagePicker();

  /// 캘린더 수정 뷰모델
  CalendarEditViewModel({CalendarModel? initialCalendarData}) {
    if (initialCalendarData != null) {
      _calendar = initialCalendarData;
      _initialCalendar = initialCalendarData; // 초기 상태 저장
    }
  }

  /// 방장 권한 넘김
  Future<void> transferAdminRole(String newAdminId) async {
    await CalendarDataSource.instance.transferAdminRole(
      _calendar.id,
      newAdminId,
    );
  }

  /// 이미지 옵션 선택
  Future<void> pickImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("사진 촬영"),
                onTap: () async {
                  Navigator.pop(context);
                  _pickProfileImageCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("앨범에서 선택"),
                onTap: () async {
                  Navigator.pop(context);
                  _pickProfileImageAlbum();
                },
              ),
              ListTile(
                leading: const Icon(Icons.no_photography_outlined),
                title: const Text("이미지 삭제"),
                onTap: () async {
                  Navigator.pop(context);
                  _deleteImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 카메라에서 이미지를 가져오기
  Future<void> _pickProfileImageCamera() async {
    // 카메라에서 선택된 이미지
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      _newImage = File(pickedFile.path); //이미지 가져와서 _image에 로컬 경로 저장
    }
    notifyListeners();
  }

  /// 갤러리에서 이미지를 가져오기
  Future<void> _pickProfileImageAlbum() async {
    // 갤러리에서 선택된 이미지
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _newImage = File(pickedFile.path); //이미지 가져와서 _image에 로컬 경로 저장
    }
    notifyListeners();
  }

  /// 이미지 지우기
  Future<void> _deleteImage() async {
    _newImage = null;
    _calendar = _calendar.copyWith(imageURL: null);
    notifyListeners();
  }

  /// 선택한 이미지 supabase storage 에 저장
  Future<String?> _uploadCalendarImage() async {
    if (_newImage == null) return null;

    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final file = _newImage!;
    final extension = file.path.split('.').last;
    final filePath =
        'calendar-images/${user.id}/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage
        .from('calendar-images')
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    return supabase.storage.from('calendar-images').getPublicUrl(filePath);
  }

  /// 캘린더 정보 업데이트
  Future<bool> updateCalendarInfo() async {
    String? finalImageUrl;

    if (_newImage != null) {
      finalImageUrl = await _uploadCalendarImage();
    } else {
      finalImageUrl = _calendar.imageURL;
    }

    final bool result = await CalendarDataSource.instance.updateCalendarInfo(
      _titleController.text,
      _descController.text,
      finalImageUrl,
      _calendar.id,
    );

    return result;
  }

  /// 컨트롤러 dispose
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
