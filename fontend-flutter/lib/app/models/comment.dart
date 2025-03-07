// models/comment.dart
import 'package:frontend/app/models/user.dart';

class Comment {
  final int id;
  final String body;
  final User user; // Ajoutez l'objet User ici
  final int postId;

  Comment({
    required this.id,
    required this.body,
    required this.user, // Mettez à jour ce champ
    required this.postId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      body: json['body'],
      user: User.fromJson(json['user']), // Assurez-vous que le backend renvoie `user`
      postId: json['post_id'],
    );
  }
}