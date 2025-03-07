// models/like.dart
class Like {
  final int id;
  final int userId;
  final int postId;

  Like({
    required this.id,
    required this.userId,
    required this.postId,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
    );
  }
}