import 'dart:io';

import 'package:dutytable/features/calendar/domain/entities/calendar_entity.dart';
import 'package:dutytable/features/calendar/domain/usecases/transfer_admin_role_use_case.dart';
import 'package:dutytable/features/calendar/domain/usecases/update_calendar_info_use_case.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/device_resource_service.dart';
import '../../../../core/services/supabase_storage_service.dart';

enum ViewState { loading, success, error }

class CalendarEditViewModel extends ChangeNotifier {
  // UseCases
  final TransferAdminRoleUseCase _transferAdminRoleUseCase =
      getIt<TransferAdminRoleUseCase>();

  final UpdateCalendarInfoUseCase _updateCalendarInfoUseCase =
      getIt<UpdateCalendarInfoUseCase>();

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
  late final CalendarEntity _initialCalendar; // 초기 데이터 값
  late CalendarEntity _calendar;

  /// 캘린더 데이터(public)
  CalendarEntity get initialCalendar => _initialCalendar; // 초기 데이터 값
  CalendarEntity get calendar => _calendar;

  // 이미지 피커로 갤러리에서 사진 가져오기
  File? _newImage;
  File? get newImage => _newImage;

  ///삭제할 이미지 URL(private)
  String? _deleteImageURL;

  /// 디바이스 리소스 서비스(private)
  final DeviceResourceService _resourceService = DeviceResourceService();

  /// 캘린더 수정 뷰모델
  CalendarEditViewModel({CalendarEntity? initialCalendarData}) {
    if (initialCalendarData != null) {
      _calendar = initialCalendarData;
      _initialCalendar = initialCalendarData; // 초기 상태 저장
    }
  }

  /// 방장 권한 넘김
  Future<void> transferAdminRole(String newAdminId) async {
    await _transferAdminRoleUseCase(_calendar.id, newAdminId);
  }

  /// 이미지 선택
  Future<void> pickCalendarImage(ImageSource source) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      final File? pickedFile = await _resourceService.pickImage(source);
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

  /// 이미지 삭제
  Future<void> deleteImage() async {
    _newImage = null;
    _deleteImageURL = _calendar.imageUrl;
    _calendar = _calendar.copyWith(clearImageUrl: true);
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
        finalImageUrl = _calendar.imageUrl;
      }

      if (_deleteImageURL != null) {
        await SupabaseStorageService().deleteCalendarImage(
          _deleteImageURL ?? "",
        );
      }

      result = await _updateCalendarInfoUseCase(
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
