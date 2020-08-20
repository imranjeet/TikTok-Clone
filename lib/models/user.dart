class User {
  int id;
  String name;
  String email;
  String password;
  String fcmToken;

  toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };
  }
}
