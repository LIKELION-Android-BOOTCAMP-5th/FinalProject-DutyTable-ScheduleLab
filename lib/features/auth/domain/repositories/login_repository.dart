import '../../data/models/login_result_model.dart';

abstract class LoginRepository {
  Future<bool> init(bool isOnboarding);
  Future<LoginResultModel> googleSignIn(bool isAutoLogin);
  Future<LoginResultModel> signInWithApple(bool isAutoLogin);
}
