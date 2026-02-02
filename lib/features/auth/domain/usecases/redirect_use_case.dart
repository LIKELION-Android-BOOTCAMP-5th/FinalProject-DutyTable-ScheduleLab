import 'package:dutytable/features/auth/domain/repositories/local_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class RedirectUseCase {
  final LocalRepository repository;
  RedirectUseCase(this.repository);

  Future<void> call(BuildContext context) async {
    await repository.redirect(context);
  }
}
