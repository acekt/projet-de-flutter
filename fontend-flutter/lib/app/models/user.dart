class User {
  final int id;
  final String name;
  final String email;
  final String? image; // Champ optionnel
  final String token; // Champ obligatoire

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Valeur par défaut si 'id' est null
      name: json['name'] ?? '', // Valeur par défaut si 'name' est null
      email: json['email'] ?? '', // Valeur par défaut si 'email' est null
      image: json['image'], // Peut être null
      token: json['token'] ?? '', // Valeur par défaut si 'token' est null
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? image,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      token: token ?? this.token,
    );
  }

  // Méthode pour convertir l'objet User en Map (utile pour le débogage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'token': token,
    };
  }
}