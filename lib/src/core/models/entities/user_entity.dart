class UserEntity {
  String? name;
  String? email;
  String? urlImage;

  UserEntity({
    required this.name,
    required this.email,
    this.urlImage,
  });
}
