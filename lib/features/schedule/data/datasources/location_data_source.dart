import 'package:dutytable/features/schedule/data/models/geocode_result_model.dart';
import 'package:dutytable/features/schedule/data/models/location_search_result_model.dart';

abstract class LocationDataSource {
  Future<List<LocationSearchResultModel>> searchAddress(String keyword);
  Future<GeocodeResultModel> geocodeAddress(String address);
}
