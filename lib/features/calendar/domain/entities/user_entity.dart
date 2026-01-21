class UserEntity {
  final String id;
  final String nickname;
  final String? profileUrl;

  UserEntity({required this.id, required this.nickname, this.profileUrl});
}
