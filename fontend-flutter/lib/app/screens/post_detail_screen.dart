import 'package:flutter/material.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/models/comment.dart';
import 'package:frontend/app/services/api_service.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
  }

  Future<void> _fetchPostDetails() async {
    try {
      final apiService = ApiService();
      final response = await apiService.get('post/${widget.postId}', token: 'YOUR_TOKEN_HERE');
      setState(() {
        post = Post.fromJson(response['post']);
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Post'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post!.user.image != null
                      ? NetworkImage(post!.user.image!)
                      : null,
                  child: post!.user.image == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 8.0),
                Text(
                  post!.user.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              post!.body,
              style: const TextStyle(fontSize: 18.0),
            ),
            if (post!.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.network(post!.imageUrl!),
              ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    // Gérer le like
                  },
                ),
                Text('${post!.likes.length}'),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Commentaires',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            ...post!.comments.map((comment) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: comment.user.image != null
                      ? NetworkImage(comment.user.image!)
                      : null,
                  child: comment.user.image == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(comment.user.name),
                subtitle: Text(comment.body),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}