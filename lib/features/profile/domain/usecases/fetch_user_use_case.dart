import 'package:dutytable/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchUserUseCase {
  final ProfileRepository repository;
  FetchUserUseCase(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.fetchUser();
  }
}
