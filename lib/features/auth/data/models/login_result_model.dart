enum PostLoginRoute { signup, shared }

class LoginResultModel {
  final bool success;
  final PostLoginRoute? route;
  final String? message;

  const LoginResultModel._({
    required this.success,
    this.route,
    this.message,
  });

  factory LoginResultModel.signup() {
    return const LoginResultModel._(
      success: true,
      route: PostLoginRoute.signup,
    );
  }

  factory LoginResultModel.shared() {
    return const LoginResultModel._(
      success: true,
      route: PostLoginRoute.shared,
    );
  }

  factory LoginResultModel.fail(String message) {
    return LoginResultModel._(
      success: false,
      message: message,
    );
  }
}
