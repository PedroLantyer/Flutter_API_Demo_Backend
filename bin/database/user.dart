class User {
  int? id;
  String? username, email, password;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {"id": id, "username": username, "email": email, "password": email};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      username: map["username"],
      email: map["email"],
      password: map["password"],
    );
  }
}
