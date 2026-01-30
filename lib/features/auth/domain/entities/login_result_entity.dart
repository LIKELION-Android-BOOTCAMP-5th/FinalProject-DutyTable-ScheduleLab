import '../../data/models/login_result_model.dart';

class LoginResultEntity {
  final bool success;
  final PostLoginRoute? route;
  final String? message;

  const LoginResultEntity({required this.success, this.route, this.message});
}
