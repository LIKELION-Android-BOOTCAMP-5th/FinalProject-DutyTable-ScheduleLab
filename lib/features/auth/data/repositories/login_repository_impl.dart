import 'package:dutytable/features/auth/data/datasources/auth_data_source.dart';
import 'package:dutytable/features/auth/data/datasources/local_data_source.dart';
import 'package:dutytable/features/auth/data/datasources/user_data_source.dart';
import 'package:dutytable/features/auth/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

import '../models/login_result_model.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LocalDataSource dataSource;
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;

  LoginRepositoryImpl(
    this.dataSource,
    this.authDataSource,
    this.userDataSource,
  );

  @override
  Future<LoginResultModel> googleSignIn(bool isAutoLogin) async {
    await authDataSource.signInWithGoogle();
    await dataSource.setAutoLogin(isAutoLogin);
    final result = await userDataSource.postLoginProcess();
    return result;
  }

  @override
  Future<bool> checkOnboardingStatus() {
    return dataSource.isOnboardingDone();
  }

  @override
  Future<LoginResultModel> signInWithApple(bool isAutoLogin) async {
    await authDataSource.signInWithGoogle();
    await dataSource.setAutoLogin(isAutoLogin);
    final result = await userDataSource.postLoginProcess();
    return result;
  }
}
