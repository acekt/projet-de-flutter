// models/post.dart
import 'package:frontend/app/models/comment.dart';
import 'package:frontend/app/models/like.dart';
import 'package:frontend/app/models/user.dart';

class Post {
  final int id;
  final String body;
  final String? imageUrl;
  final User user; // Ajoutez l'objet User ici
  final List<Comment> comments;
  final List<Like> likes;

  Post({
    required this.id,
    required this.body,
    this.imageUrl,
    required this.user, // Mettez à jour ce champ
    required this.comments,
    required this.likes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      body: json['body'],
      imageUrl: json['image_url'],
      user: User.fromJson(json['user']), // Assurez-vous que le backend renvoie `user`
      comments: List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x))),
      likes: List<Like>.from(json['likes'].map((x) => Like.fromJson(x))),
    );
  }
}