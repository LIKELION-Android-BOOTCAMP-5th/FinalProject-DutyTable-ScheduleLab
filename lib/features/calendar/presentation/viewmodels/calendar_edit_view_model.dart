import 'dart:io';

import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:dutytable/features/calendar/data/models/calendar_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/supabase_storage_service.dart';

enum ViewState { loading, success, error }

class CalendarEditViewModel extends ChangeNotifier {
  /// 데이터 로딩 상태(private)
  ViewState _state = ViewState.success;

  /// 데이터 로딩 상태(public)
  ViewState get state => _state;

  /// 에러 메세지(private)
  String? _errorMessage;

  /// 에러 메세지(public)
  String? get errorMessage => _errorMessage;

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

  ///삭제할 이미지 URL(private)
  String? _deleteImageURL;

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
                  _pickProfileImage('camera');
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("앨범에서 선택"),
                onTap: () async {
                  Navigator.pop(context);
                  _pickProfileImage('gallery');
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

  /// 이미지 가져오기
  Future<void> _pickProfileImage(String type) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final XFile? pickedFile = await picker.pickImage(
        source: type == 'camera' ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedFile != null) {
        _newImage = File(pickedFile.path);
        _state = ViewState.success;
      } else {
        _state = ViewState.success;
      }
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// 이미지 지우기
  Future<void> _deleteImage() async {
    _newImage = null;
    _deleteImageURL = _calendar.imageURL;
    _calendar = _calendar.copyWith(imageURL: null);
    notifyListeners();
  }

  /// 캘린더 정보 업데이트
  Future<bool> updateCalendarInfo() async {
    String? finalImageUrl;
    bool result = false;

    _state = ViewState.loading;
    notifyListeners();

    try {
      if (_newImage != null) {
        finalImageUrl = await SupabaseStorageService().uploadCalendarImage(
          _newImage,
          calendar.id,
        );
      } else {
        finalImageUrl = _calendar.imageURL;
      }

      if (_deleteImageURL != null) {
        await SupabaseStorageService().deleteCalendarImage(
          _deleteImageURL ?? "",
        );
      }

      result = await CalendarDataSource.instance.updateCalendarInfo(
        title: _titleController.text,
        description: _descController.text,
        imageURL: finalImageUrl,
        calendarId: _calendar.id,
      );
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString();
    }
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
