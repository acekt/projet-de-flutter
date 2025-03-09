import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/app/controllers/post_controller.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/models/comment.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;
  final String token;

  const PostDetailScreen({super.key, required this.postId, required this.token});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    final post = postController.posts.firstWhere((post) => post.id == postId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.user.image ?? ''),
                ),
                const SizedBox(width: 8.0),
                Text(
                  post.user.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              post.body,
              style: const TextStyle(fontSize: 18.0),
            ),
            if (post.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.network(post.imageUrl!),
              ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    postController.toggleLike(post.id, token);
                  },
                ),
                Obx(() {
                  final updatedPost = postController.posts.firstWhere((p) => p.id == postId);
                  return Text('${updatedPost.likes} likes');
                }),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Commentaires',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            ...post.comments.map((comment) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(comment.user.image ?? ''),
                ),
                title: Text(comment.user.name),
                subtitle: Text(comment.body),
              );
            }).toList(),
            const SizedBox(height: 16.0),
            TextField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                labelText: 'Ajouter un commentaire',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (commentBody) {
                postController.addComment(post.id, commentBody, token);
              },
            ),
          ],
        ),
      ),
    );
  }
}