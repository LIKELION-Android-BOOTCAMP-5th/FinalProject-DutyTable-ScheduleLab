import 'package:dutytable/features/schedule/domain/entities/location_search_result_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchAddressUseCase {
  final LocationRepository repository;

  SearchAddressUseCase(this.repository);

  Future<List<LocationSearchResultEntity>> call(String keyword) {
    return repository.searchAddress(keyword);
  }
}
