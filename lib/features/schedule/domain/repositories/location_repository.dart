import 'package:dutytable/features/schedule/domain/entities/geocode_result_entity.dart';
import 'package:dutytable/features/schedule/domain/entities/location_search_result_entity.dart';

abstract class LocationRepository {
  Future<List<LocationSearchResultEntity>> searchAddress(String keyword);
  Future<GeocodeResultEntity> geocodeAddress(String address);
}
