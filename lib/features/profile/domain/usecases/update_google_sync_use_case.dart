import 'package:dutytable/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateGoogleSyncUseCase {
  final ProfileRepository repository;
  UpdateGoogleSyncUseCase(this.repository);
  Future<void> call(String userId, bool syncStatus) async {
    await repository.updateGoogleSync(userId, syncStatus);
  }
}
