import 'package:dutytable/features/schedule/data/models/geocode_result_model.dart';
import 'package:dutytable/features/schedule/domain/entities/geocode_result_entity.dart';

extension GeocodeResultMapper on GeocodeResultModel {
  GeocodeResultEntity toEntity() {
    return GeocodeResultEntity(latitude: latitude, longitude: longitude);
  }
}

extension ScheduleEntityMapper on GeocodeResultEntity {
  GeocodeResultModel toModel() {
    return GeocodeResultModel(latitude: latitude, longitude: longitude);
  }
}
