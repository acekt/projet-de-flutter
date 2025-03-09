class User {
  final int id;
  final String name;
  final String email;
  final String? image;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      token: json['token'] ?? '',
    );
  }
}