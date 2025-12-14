import 'dart:io';

import 'package:dutytable/features/calendar/data/datasources/calendar_data_source.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';
import '../../data/datasources/user_data_source.dart';

class CalendarAddViewModel extends ChangeNotifier {
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

  /// 갤러리에서 프로필 이미지를 선택하는 함수
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _imageFile = File(image.path);
      notifyListeners();
    }
  }

  /// 선택한 이미지 supabase storage 에 저장
  Future<String?> _uploadCalendarImage() async {
    if (_imageFile == null) return null;

    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final file = _imageFile!;
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

  /// 멤버 추가
  Future<void> addInvitedUserByNickname(String nickname) async {
    final value = nickname.trim();

    if (value.isEmpty) {
      _setInviteError('닉네임을 입력해주세요');
      return;
    }

    final user = await UserDataSource.shared.findUserByNickname(value);

    if (user == null) {
      _setInviteError('존재하지 않는 사용자입니다');
      return;
    }

    final userId = user['id']!;
    final userNickname = user['nickname']!;

    if (_invitedUsers.containsKey(userId)) {
      _setInviteError('이미 추가된 사용자입니다');
      return;
    }

    // ✅ 성공
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
      final imageUrl = await _uploadCalendarImage();

      await CalendarDataSource.shared.addSharedCalendar(
        title: _title,
        imageURL: imageUrl,
        description: _description,
        invitedUserIds: _invitedUsers.keys.toList(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
