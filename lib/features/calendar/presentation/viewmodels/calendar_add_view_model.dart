import 'dart:io';

import 'package:dutytable/core/services/supabase_storage_service.dart';
import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/device_resource_service.dart';
import '../../../../main.dart';
import '../../data/datasources/user_data_source.dart';

class CalendarAddViewModel extends ChangeNotifier {
  /// 디바이스 리소스 서비스(private)
  final DeviceResourceService _resourceService = DeviceResourceService();
  bool _isLoading = false;

  File? _imageFile;
  final Map<String, String> _invitedUsers = {};
  String? _inviteError;
  String _title = '';
  String? _description;

  bool get isLoading => _isLoading;

  File? get imageFile => _imageFile;
  Map<String, String> get invitedUsers => _invitedUsers;
  String? get inviteError => _inviteError;
  String get title => _title;
  String? get description => _description;

  bool get isValid => _title.trim().isNotEmpty;

  void clearError() {
    _inviteError = null;
    notifyListeners();
  }

  void addInvitedUser({required String userId, required String nickname}) {
    if (_invitedUsers.containsKey(userId)) return;

    _invitedUsers[userId] = nickname;
    notifyListeners();
  }

  void removeInvitedUser(String userId) {
    _invitedUsers.remove(userId);
    notifyListeners();
  }

  void _setInviteError(String? value) {
    _inviteError = value;
    notifyListeners();
  }

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setDescription(String? value) {
    _description = value;
    notifyListeners();
  }

  /// 이미지 선택
  Future<void> pickProfileImage(ImageSource source) async {
    final File? pickedFile = await _resourceService.pickImage(source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  /// 이미지 삭제
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

    final user = await UserDataSource.shared.findUserByNickname(value);

    if (user == null) {
      _setInviteError('존재하지 않는 사용자입니다.');
      return;
    }

    final userId = user['id']!;
    final userNickname = user['nickname']!;

    if (_invitedUsers.containsKey(userId)) {
      _setInviteError('이미 추가된 사용자입니다.');
      return;
    }

    if (userId == currentUser!.id) {
      _setInviteError('자신은 추가 할 수 없습니다.');
      return;
    }

    _invitedUsers[userId] = userNickname;
    _setInviteError(null); // 에러 제거
  }

  /// 캘린더 추가
  Future<void> addSharedCalendar() async {
    if (_isLoading) return;
    if (!isValid) throw Exception('캘린더 이름은 필수입니다.');

    _isLoading = true;
    notifyListeners();

    try {
      // 1. 이미지 없이 캘린더 생성 후 캘린더 id 받아오기
      final calendarId = await CalendarDataSource.instance.addSharedCalendar(
        title: _title,
        description: _description,
        invitedUserIds: _invitedUsers.keys.toList(),
      );

      // 2. 받아온 캘린더 id로 storage에 이미지 저장
      final imageUrl = await SupabaseStorageService().uploadCalendarImage(
        _imageFile,
        calendarId,
      );

      // 3. storage에 저장한 이미지 캘린더에 업데이트
      await CalendarDataSource.instance.updateCalendarInfo(
        imageURL: imageUrl,
        calendarId: calendarId,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
