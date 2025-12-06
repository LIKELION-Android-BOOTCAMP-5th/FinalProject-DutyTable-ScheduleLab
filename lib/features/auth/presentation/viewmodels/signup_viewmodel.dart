import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../main.dart';

class SignupViewModel with ChangeNotifier {
  // 텍스트 필드 컨트롤러
  final TextEditingController nicknameController = TextEditingController();

  // 상태 변수
  bool _isNicknameValid = false;
  bool _isNicknameChecked = false;
  bool _isTermsAgreed = false;
  bool _isLoading = false;
  bool _hasViewedTerms = false;
  String? _lastCheckedNickname; // 마지막으로 중복 체크한 닉네임 저장
  String? nicknameMessage;
  bool isNicknameMessageError = false;

  // Getter
  bool get isNicknameValid => _isNicknameValid;
  bool get isNicknameChecked => _isNicknameChecked;
  bool get isTermsAgreed => _isTermsAgreed;
  bool get isLoading => _isLoading;
  bool get hasViewedTerms => _hasViewedTerms;

  // 모든 조건이 충족되었는지 확인
  bool get isFormComplete =>
      _isNicknameChecked && _isTermsAgreed && !_isLoading;

  SignupViewModel() {
    // 닉네임 입력이 변경될 때마다 유효성 검사
    nicknameController.addListener(_validateNickname);
  }

  void viewTerms() {
    _hasViewedTerms = true;
    notifyListeners();
  }

  // 닉네임 입력 유효성 검사 (예: 2자 이상)
  void _validateNickname() {
    final newNickname = nicknameController.text;
    final isValid = newNickname.length >= 2;

    if (_isNicknameValid != isValid) {
      _isNicknameValid = isValid;
    }

    // 닉네임이 이전에 중복 체크 완료된 닉네임과 같다면, 체크 상태를 복원
    if (_lastCheckedNickname != null && newNickname == _lastCheckedNickname) {
      _isNicknameChecked = true;
      nicknameMessage = '사용 가능한 닉네임입니다.';
      isNicknameMessageError = false;
    } else {
      // 그렇지 않다면, 체크 상태를 초기화하고 유효성에 따라 메시지 설정
      _isNicknameChecked = false;
      if (newNickname.isNotEmpty && !isValid) {
        nicknameMessage = '2글자 이상 입력해주세요.';
        isNicknameMessageError = true;
      } else if (isValid) {
        nicknameMessage = '중복 체크를 해주세요.';
        isNicknameMessageError = true;
      } else {
        nicknameMessage = null; // 2글자 미만이거나 비어있을 때
      }
    }
    notifyListeners();
  }

  // 약관 동의 상태 토글
  void toggleTermsAgreement(bool? newValue) {
    _isTermsAgreed = newValue ?? false;
    notifyListeners();
  }

  // 로딩 상태 변경
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 닉네임 중복 체크 로직
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
      final response = await supabase
          .from('users')
          .select('nickname')
          .eq('nickname', nicknameToTest)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        _isNicknameChecked = true;
        _lastCheckedNickname = nicknameToTest; // 성공 시 닉네임 저장
        nicknameMessage = '사용 가능한 닉네임입니다.';
        isNicknameMessageError = false;
      } else {
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
      notifyListeners();
    }
  }

  // 회원가입 완료 로직 (프로필 정보 업데이트)
  Future<void> completeSignup(BuildContext context) async {
    if (!isFormComplete) return;

    _setLoading(true);

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User is not authenticated. Cannot complete signup.');
      }

      final updates = {
        'id': currentUser.id,
        'email': currentUser.email,
        'nickname': nicknameController.text.trim(),
        'is_google_calendar_connect': false,
        'allowed_notification': true,
      };

      await supabase.from('users').upsert(updates, onConflict: 'id');

      // 회원가입 성공 후 메인 화면으로 이동
      GoRouter.of(context).go('/shared');
    } on AuthException catch (e) {
      _showErrorDialog(context, '인증 오류: ${e.message}');
    } on PostgrestException catch (e) {
      _showErrorDialog(
        context,
        '데이터베이스 오류: ${e.message}\n\n(코드: ${e.code})\n\n세부 정보: ${e.details}',
      );
    } catch (e) {
      _showErrorDialog(context, '알 수 없는 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 오류 메시지를 사용자에게 보여주는 함수
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nicknameController.removeListener(_validateNickname);
    nicknameController.dispose();
    super.dispose();
  }
}
