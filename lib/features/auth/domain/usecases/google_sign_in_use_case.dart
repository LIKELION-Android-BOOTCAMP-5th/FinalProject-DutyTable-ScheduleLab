import 'package:dutytable/features/auth/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/login_result_model.dart';

@injectable
class GoogleSignInUseCase {
  final LoginRepository repository;
  GoogleSignInUseCase(this.repository);

  Future<LoginResultModel> call(bool isAutoLogin) async {
    return await repository.googleSignIn(isAutoLogin);
  }
}
