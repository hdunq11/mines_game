class UserModel {
  final String email;
  final String password;

  UserModel({
    required this.email,
    required this.password,
  });

  Map<String, Object?> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}