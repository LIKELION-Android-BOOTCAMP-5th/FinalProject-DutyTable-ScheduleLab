import 'package:dutytable/features/schedule/data/models/location_search_result_model.dart';
import 'package:dutytable/features/schedule/domain/entities/location_search_result_entity.dart';

extension LocationSearchResultModelMapper on LocationSearchResultModel {
  LocationSearchResultEntity toEntity() {
    return LocationSearchResultEntity(title: title, address: address);
  }
}

extension LocationSearchResultEntityMapper on LocationSearchResultEntity {
  LocationSearchResultModel toModel() {
    return LocationSearchResultModel(title: title, address: address);
  }
}
