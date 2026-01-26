import 'package:dutytable/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateimageUseCase {
  final ProfileRepository repository;
  UpdateimageUseCase(this.repository);

  Future<void> call(String userId, String? publicUrl) async {
    await repository.updateImage(userId, publicUrl);
  }
}
