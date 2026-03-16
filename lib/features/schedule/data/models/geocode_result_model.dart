class GeocodeResultModel {
  final String latitude;
  final String longitude;

  GeocodeResultModel({required this.latitude, required this.longitude});

  factory GeocodeResultModel.fromJson(Map<String, dynamic> json) {
    return GeocodeResultModel(
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
