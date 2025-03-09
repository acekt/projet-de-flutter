import 'package:frontend/app/models/user.dart';

class Comment {
  final int id;
  final String body;
  final int userId;
  final int postId;
  final DateTime createdAt;
  final User user; // Ajout du champ user

  Comment({
    required this.id,
    required this.body,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      body: json['body'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: DateTime.parse(json['created_at']),
      user: User.fromJson(json['user']), // Désérialisation de l'utilisateur
    );
  }
}