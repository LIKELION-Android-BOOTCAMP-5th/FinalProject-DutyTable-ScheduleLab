import 'package:dutytable/features/schedule/domain/entities/geocode_result_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GeocodeAddressUseCase {
  final LocationRepository repository;

  GeocodeAddressUseCase(this.repository);

  Future<GeocodeResultEntity> call(String address) {
    return repository.geocodeAddress(address);
  }
}
