import 'package:flutter/material.dart';
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

  // Getter
  bool get isNicknameValid => _isNicknameValid;
  bool get isNicknameChecked => _isNicknameChecked;
  bool get isTermsAgreed => _isTermsAgreed;
  bool get isLoading => _isLoading;

  // 모든 조건이 충족되었는지 확인
  bool get isFormComplete =>
      _isNicknameChecked && _isTermsAgreed && !_isLoading;

  SignupViewModel() {
    // 닉네임 입력이 변경될 때마다 유효성 검사 및 중복 체크 상태 초기화
    nicknameController.addListener(_validateNickname);
  }

  // 닉네임 입력 유효성 검사 (예: 2자 이상)
  void _validateNickname() {
    final isValid = nicknameController.text.length >= 2;
    if (_isNicknameValid != isValid) {
      _isNicknameValid = isValid;
      _isNicknameChecked = false; // 닉네임이 바뀌면 중복 체크 상태 초기화
      notifyListeners();
    }
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
    if (!isNicknameValid) return;

    _setLoading(true);
    try {
      final response = await supabase
          .from('users')
          .select('nickname')
          .eq('nickname', nicknameController.text)
          .limit(1)
          .maybeSingle();

      // Supabase 응답이 null이면 중복 없음
      if (response == null) {
        _isNicknameChecked = true;
        // 실제로는 사용자에게 "사용 가능" 메시지를 보여줘야 함
        print('닉네임 사용 가능');
      } else {
        _isNicknameChecked = false;
        // 실제로는 사용자에게 "중복됨" 메시지를 보여줘야 함
        print('닉네임 중복됨');
      }
    } catch (e) {
      print('닉네임 중복 체크 중 오류 발생: $e');
      _isNicknameChecked = false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // 회원가입 완료 로직 (Supabase Auth 및 DB 저장)
  Future<void> completeSignup(BuildContext context) async {
    if (!isFormComplete) return;

    _setLoading(true);

    try {
      // Supabase DB: users 테이블에 닉네임 저장
      final user = await supabase
          .from('users')
          .insert({
            'nickname': nicknameController.text,
            'email': 'temp_email@example.com', // 임시값. 실제로는 Auth에서 얻어야 함
            'is_google_calendar_enabled': false,
            'allowed_notification': true,
          })
          .select()
          .maybeSingle();

      if (user != null) {
        print('회원가입 (DB 저장) 성공: $user');
        // 회원가입 성공 후 로그인 화면으로 돌아가기
        Navigator.of(context).pop();
      } else {
        // DB 삽입 실패 처리
        _showErrorDialog(context, '데이터 저장에 실패했습니다. 다시 시도해 주세요.');
      }
    } on AuthException catch (e) {
      _showErrorDialog(context, '인증 오류: ${e.message}');
    } catch (e) {
      _showErrorDialog(context, '오류 발생: 알 수 없는 오류가 발생했습니다.');
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
