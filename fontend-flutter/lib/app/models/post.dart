import 'package:frontend/app/models/user.dart';
import 'comment.dart';

class Post {
  final int id;
  final String body;
  final String? imageUrl;
  final User user;
  final List<Comment> comments;
  final int likes;

  Post({
    required this.id,
    required this.body,
    this.imageUrl,
    required this.user,
    required this.comments,
    required this.likes,
  });

  // Méthode fromJson pour créer un Post à partir d'un JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      body: json['body'],
      imageUrl: json['image_url'],
      user: User.fromJson(json['user']),
      comments: json['comments'] != null
          ? List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x)))
          : [],
      likes: json['likes_count'] ?? 0,
    );
  }

  // Méthode copyWith pour créer une nouvelle instance de Post avec des propriétés modifiées
  Post copyWith({
    int? id,
    String? body,
    String? imageUrl,
    User? user,
    List<Comment>? comments,
    int? likes,
  }) {
    return Post(
      id: id ?? this.id,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      user: user ?? this.user,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
    );
  }
}