class Cuser {
  int id;
  String name;
  String email;
  String password;

  Cuser({
    this.id,
    this.name,
    this.email,
    this.password,
  });

  factory Cuser.fromJson(Map<String, dynamic> json) {
    return Cuser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}
