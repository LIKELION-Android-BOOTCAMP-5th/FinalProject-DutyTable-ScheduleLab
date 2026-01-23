import 'package:dutytable/features/schedule/data/datasources/location_data_source.dart';
import 'package:dutytable/features/schedule/data/models/geocode_result_model.dart';
import 'package:dutytable/features/schedule/data/models/location_search_result_model.dart';
import 'package:dutytable/main.dart';

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<List<LocationSearchResultModel>> searchAddress(String keyword) async {
    final response = await supabase.functions.invoke(
      'hyper-endpoint',
      body: {'type': 'search', 'query': keyword},
    );

    if (response.data == null) {
      throw Exception("search address failed");
    }

    final List list = response.data as List;

    return list
        .map(
          (e) =>
              LocationSearchResultModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  @override
  Future<GeocodeResultModel> geocodeAddress(String address) async {
    final response = await supabase.functions.invoke(
      'hyper-endpoint',
      body: {'type': 'geocode', 'address': address},
    );

    if (response.data == null) {
      throw Exception('Geocode failed');
    }

    return GeocodeResultModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}
