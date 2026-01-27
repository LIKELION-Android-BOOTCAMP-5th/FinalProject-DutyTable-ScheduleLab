import 'dart:io';

import 'package:dutytable/features/calendar/domain/entities/user_entity.dart';
import 'package:dutytable/features/calendar/domain/usecases/find_user_by_nickname_use_case.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/services/device_resource_service.dart';
import '../../../../main.dart';
import '../../domain/usecases/create_shared_calendar_use_case.dart';

@injectable
class CalendarAddViewModel extends ChangeNotifier {
  final CreateSharedCalendarUseCase _createSharedCalendarUseCase;
  final FindUserByNicknameUseCase _findUserByNicknameUseCase;

  /// 디바이스 리소스 서비스(private)
  final DeviceResourceService _resourceService = DeviceResourceService();

  /// 데이터 로딩 상태(private)
  bool _isLoading = false;

  /// 캘린더 이미지(private)
  File? _imageFile;

  /// 초대 유저들(private)
  final List<UserEntity> _invitedUsers = [];

  /// 초대 에러(private)
  String? _inviteError;

  /// 캘린더 제목(private)
  String _title = '';

  /// 캘린더 설명(private)
  String? _description;

  /// 데이터 로딩 상태(public)
  bool get isLoading => _isLoading;

  /// 캘린더 이미지(public)
  File? get imageFile => _imageFile;

  /// 초대 유저들(public)
  List<UserEntity> get invitedUsers => _invitedUsers;

  /// 초대 에러(public)
  String? get inviteError => _inviteError;

  /// 캘린더 제목(public)
  String get title => _title;

  /// 캘린더 설명(public)
  String? get description => _description;

  bool get isValid => _title.trim().isNotEmpty;

  CalendarAddViewModel(
    this._createSharedCalendarUseCase,
    this._findUserByNicknameUseCase,
  );

  /// 에러 지우기
  void clearError() {
    _inviteError = null;
    notifyListeners();
  }

  /// 초대 유저 지우기
  void removeInvitedUser(String userId) {
    _invitedUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
  }

  /// 초대 에러 표시
  void _setInviteError(String? value) {
    _inviteError = value;
    notifyListeners();
  }

  /// 캘린더 제목 작성
  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  /// 캘린더 설명 작성
  void setDescription(String? value) {
    _description = value;
    notifyListeners();
  }

  /// 캘린더 이미지 선택
  Future<void> pickCalendarImage(ImageSource source) async {
    final File? pickedFile = await _resourceService.pickImage(source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  /// 캘린더 이미지 삭제
  Future<void> deleteImage() async {
    _imageFile = null;
    notifyListeners();
  }

  /// 멤버 추가
  Future<void> addInvitedUserByNickname(String nickname) async {
    final value = nickname.trim();

    final currentUser = supabase.auth.currentUser;

    if (value.isEmpty) {
      _setInviteError('닉네임을 입력해주세요');
      return;
    }

    final user = await _findUserByNicknameUseCase(value);

    if (user == null) {
      _setInviteError('존재하지 않는 사용자입니다.');
      return;
    }

    if (user.id == currentUser!.id) {
      _setInviteError('자신은 추가 할 수 없습니다.');
      return;
    }

    final isAlreadyAdded = _invitedUsers.any((u) => u.id == user.id);
    if (isAlreadyAdded) {
      _setInviteError('이미 추가된 사용자입니다.');
      return;
    }
    _invitedUsers.add(user);
    _setInviteError(null); // 에러 제거
  }

  /// 캘린더 추가
  Future<void> createSharedCalendar() async {
    if (_isLoading) return;
    if (!isValid) throw Exception('캘린더 이름은 필수입니다.');

    _isLoading = true;
    notifyListeners();

    try {
      final List<String> invitedIds = _invitedUsers
          .map((user) => user.id)
          .toList();

      await _createSharedCalendarUseCase(
        title: _title,
        description: _description,
        invitedUserIds: invitedIds,
        imageFile: _imageFile,
      );
    } catch (e) {
      debugPrint("캘린더 추가 실패: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
