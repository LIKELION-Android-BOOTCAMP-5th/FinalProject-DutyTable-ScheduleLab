import 'dart:io';

import 'package:dutytable/features/auth/data/datasources/user_data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/device_resource_service.dart';
import '../../../../main.dart';

// SignupScreen의 비즈니스 로직을 담당하는 ViewModel
class SignupViewModel with ChangeNotifier {
  final TextEditingController nicknameController = TextEditingController();
  final DeviceResourceService _resourceService = DeviceResourceService();

  File? _selectedImage; // 선택된 프로필 이미지 파일
  bool _isNicknameValid = false; // 닉네임 유효성 (2글자 이상)
  bool _isNicknameChecked = false; // 닉네임 중복 확인 완료 여부
  bool _isTermsAgreed = false; // 약관 동의 여부
  bool _isLoading = false; // 로딩 상태 (중복 체크, 회원가입 등)
  bool _hasViewedTerms = false; // 약관을 한 번이라도 봤는지 여부
  String? _lastCheckedNickname; // 마지막으로 중복 확인한 닉네임
  String? nicknameMessage; // 닉네임 필드 아래에 표시될 메시지
  bool isNicknameMessageError = false; // 닉네임 메시지가 오류 메시지인지 여부
  final UserDataSource _userDataSource;

  File? get selectedImage => _selectedImage;
  bool get isNicknameValid => _isNicknameValid;
  bool get isNicknameChecked => _isNicknameChecked;
  bool get isTermsAgreed => _isTermsAgreed;
  bool get isLoading => _isLoading;
  bool get hasViewedTerms => _hasViewedTerms;

  // '완료' 버튼 활성화를 위한 최종 조건 확인
  bool get isFormComplete =>
      _isNicknameChecked && _isTermsAgreed && !_isLoading;

  SignupViewModel({UserDataSource? userDataSource})
    : _userDataSource = userDataSource ?? UserDataSource() {
    // 닉네임 컨트롤러에 리스너를 추가하여 입력이 변경될 때마다 _validateNickname 함수 호출
    nicknameController.addListener(_validateNickname);
  }

  /// 이미지 선택
  Future<void> pickProfileImage(ImageSource source) async {
    final File? pickedFile = await _resourceService.pickImage(source);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
    }
    notifyListeners();
  }

  /// 이미지 삭제
  Future<void> deleteImage() async {
    _selectedImage = null;
    notifyListeners();
  }

  // 약관을 봤음을 기록하는 함수
  void viewTerms() {
    _hasViewedTerms = true;
    notifyListeners();
  }

  // 닉네임 유효성을 검사하는 내부 함수 (2글자 이상)
  void _validateNickname() {
    final newNickname = nicknameController.text;
    final isValid = newNickname.length >= 2;

    if (_isNicknameValid != isValid) {
      _isNicknameValid = isValid;
    }

    // 이전에 중복 확인을 통과한 닉네임과 현재 닉네임이 같다면, 중복 확인 상태를 유지
    if (_lastCheckedNickname != null && newNickname == _lastCheckedNickname) {
      _isNicknameChecked = true;
      nicknameMessage = '사용 가능한 닉네임입니다.';
      isNicknameMessageError = false;
    } else {
      // 닉네임이 변경되었으므로 중복 확인 상태를 초기화
      _isNicknameChecked = false;
      if (newNickname.isNotEmpty && !isValid) {
        nicknameMessage = '2글자 이상 입력해주세요.';
        isNicknameMessageError = true;
      } else if (isValid) {
        nicknameMessage = '중복 체크를 해주세요.';
        isNicknameMessageError = true;
      } else {
        nicknameMessage = null; // 비어있을 경우 메시지 없음
      }
    }
    notifyListeners();
  }

  // 약관 동의 체크박스 상태를 변경하는 함수
  void toggleTermsAgreement(bool? newValue) {
    _isTermsAgreed = newValue ?? false;
    notifyListeners();
  }

  // 로딩 상태를 설정하고 UI에 알리는 내부 함수
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 닉네임 중복 확인 로직
  Future<void> checkNicknameDuplication() async {
    if (!isNicknameValid) {
      nicknameMessage = '2글자 이상 입력해주세요.';
      isNicknameMessageError = true;
      notifyListeners();
      return;
    }

    _setLoading(true);
    final nicknameToTest = nicknameController.text;
    try {
      final duplicated = await _userDataSource.isNicknameDuplicated(
        nicknameToTest,
      );

      if (!duplicated) {
        // 중복된 닉네임이 없는 경우
        _isNicknameChecked = true;
        _lastCheckedNickname = nicknameToTest; // 확인 완료된 닉네임 저장
        nicknameMessage = '사용 가능한 닉네임입니다.';
        isNicknameMessageError = false;
      } else {
        // 중복된 닉네임이 있는 경우
        _isNicknameChecked = false;
        _lastCheckedNickname = null;
        nicknameMessage = '중복된 닉네임입니다.';
        isNicknameMessageError = true;
      }
    } catch (e) {
      _isNicknameChecked = false;
      _lastCheckedNickname = null;
      nicknameMessage = '오류가 발생했습니다: $e';
      isNicknameMessageError = true;
    } finally {
      _setLoading(false);
    }
  }

  // 프로필 이미지를 Supabase Storage에 업로드하는 내부 함수
  Future<String> _uploadProfileImage() async {
    if (_selectedImage == null) {
      throw Exception('Image not selected');
    }

    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final imageFile = _selectedImage!;
    final imageUrl = await _userDataSource.uploadProfileImage(
      userId: currentUser.id,
      imageFile: imageFile,
    );
    return imageUrl;
  }

  // 회원가입 완료 및 프로필 정보 업데이트
  Future<void> completeSignup(BuildContext context) async {
    if (!isFormComplete) return;

    _setLoading(true);

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User is not authenticated. Cannot complete signup.');
      }

      // 프로필 이미지가 있으면 업로드하고 URL 가져오기
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadProfileImage();
      }

      // 'users' 테이블에 저장할 프로필 정보
      final updates = {
        'id': currentUser.id,
        'email': currentUser.email,
        'nickname': nicknameController.text.trim(),
        'is_google_calendar_connect': false,
        'allowed_notification': true,
        if (imageUrl != null) 'profileurl': imageUrl,
      };

      // upsert: 데이터가 없으면 새로 만들고, 있으면 업데이트
      await _userDataSource.upsertUserProfile(updates);

      // 회원가입 성공 후 메인 화면으로 이동
      if (context.mounted) {
        GoRouter.of(context).go('/shared');
      }
    } on AuthException catch (e) {
      if (context.mounted) _showErrorDialog(context, '인증 오류: ${e.message}');
    } on PostgrestException catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, '데이터베이스 오류: ${e.message}');
      }
    } catch (e) {
      if (context.mounted) _showErrorDialog(context, '알 수 없는 오류: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 에러 발생 시 사용자에게 다이얼로그를 보여주는 함수
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: <Widget>[
          TextButton(child: const Text('확인'), onPressed: () => ctx.pop()),
        ],
      ),
    );
  }

  // 생명주기

  @override
  void dispose() {
    // ViewModel이 소멸될 때 컨트롤러 리스너 및 컨트롤러 자체를 정리
    nicknameController.removeListener(_validateNickname);
    nicknameController.dispose();
    super.dispose();
  }
}
