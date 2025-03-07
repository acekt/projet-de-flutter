import 'package:flutter/material.dart';
import 'package:frontend/app/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: post.user.image != null
                        ? NetworkImage(post.user.image!)
                        : null,
                    child: post.user.image == null
                        ? const Icon(Icons.person)
                        : null,
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
                style: const TextStyle(fontSize: 16.0),
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
                      // Gérer le like
                    },
                  ),
                  Text('${post.likes.length}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}