import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.nickname, super.profileUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileUrl: json['profile_url'] as String?,
    );
  }
}
