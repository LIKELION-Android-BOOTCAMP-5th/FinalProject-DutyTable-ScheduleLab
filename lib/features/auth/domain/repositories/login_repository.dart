import '../../data/models/login_result_model.dart';

abstract class LoginRepository {
  Future<bool> checkOnboardingStatus();
  Future<LoginResultModel> googleSignIn(bool isAutoLogin);
  Future<LoginResultModel> signInWithApple(bool isAutoLogin);
}
