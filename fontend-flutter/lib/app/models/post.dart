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
}