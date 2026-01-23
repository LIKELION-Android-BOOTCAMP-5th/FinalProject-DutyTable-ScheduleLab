class GeocodeResultModel {
  final String latitude;
  final String longitude;

  GeocodeResultModel({required this.latitude, required this.longitude});

  factory GeocodeResultModel.fromJson(Map<String, dynamic> json) {
    return GeocodeResultModel(
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
