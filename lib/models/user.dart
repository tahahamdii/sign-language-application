class User {
  final String id;
  final String username;
  final String email;
  final String birthday;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      birthday: json['birthday'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'birthday': birthday,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, birthday: $birthday}';
  }
}
