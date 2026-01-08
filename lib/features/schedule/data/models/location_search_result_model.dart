class LocationSearchResultModel {
  final String title;
  final String address;

  LocationSearchResultModel({required this.title, required this.address});

  factory LocationSearchResultModel.fromJson(Map<String, dynamic> json) {
    return LocationSearchResultModel(
      title: json['title'],
      address: json['address'],
    );
  }
}
