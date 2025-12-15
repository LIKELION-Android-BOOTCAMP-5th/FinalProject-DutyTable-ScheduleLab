class AddressSearchResult {
  final String title;
  final String address;

  AddressSearchResult({required this.title, required this.address});

  factory AddressSearchResult.fromJson(Map<String, dynamic> json) {
    return AddressSearchResult(title: json['title'], address: json['address']);
  }
}
