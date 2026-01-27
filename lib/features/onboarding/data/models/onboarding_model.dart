class OnboardingModel {
  final String title;
  final String body;
  final String image;

  OnboardingModel({
    required this.title,
    required this.body,
    required this.image,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'body': body, 'image': image};
  }
}
