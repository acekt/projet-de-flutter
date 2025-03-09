import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/app/controllers/post_controller.dart';
import 'package:frontend/app/models/post.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;
  final String token;

  const PostDetailScreen({super.key, required this.postId, required this.token});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    final TextEditingController commentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Post'),
      ),
      body: Obx(() {
        final post = postController.getPostById(postId);
        if (post == null) {
          return const Center(child: Text('Post non trouvé'));
        }
        return SingleChildScrollView(
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
                    icon: Obx(() {
                      final isLiked = postController.isPostLiked(postId);
                      return Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      );
                    }),
                    onPressed: () {
                      postController.toggleLike(postId, token);
                    },
                  ),
                  Obx(() {
                    final postLikes = postController.getPostLikes(postId);
                    return Text('$postLikes likes');
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
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Ajouter un commentaire',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      postController.addComment(postId, commentController.text, token);
                      commentController.clear(); // Vider le champ de texte
                    }
                  },
                  child: const Text('Valider le commentaire'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}