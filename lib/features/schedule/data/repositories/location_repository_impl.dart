import 'package:dutytable/features/schedule/data/datasources/location_data_source.dart';
import 'package:dutytable/features/schedule/data/models/location_search_result_mapper.dart';
import 'package:dutytable/features/schedule/domain/entities/geocode_result_entity.dart';
import 'package:dutytable/features/schedule/domain/entities/location_search_result_entity.dart';
import 'package:dutytable/features/schedule/domain/repositories/location_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<List<LocationSearchResultEntity>> searchAddress(String keyword) async {
    final results = await dataSource.searchAddress(keyword);

    return results.map((result) => result.toEntity()).toList();
  }

  @override
  Future<GeocodeResultEntity> geocodeAddress(String address) async {
    final result = await dataSource.geocodeAddress(address);

    return GeocodeResultEntity(
      latitude: result.latitude,
      longitude: result.longitude,
    );
  }
}
