import 'package:flutter/material.dart';
import 'package:frontend/app/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  final VoidCallback onLikePressed; // Ajout d'un callback pour gérer les likes

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onLikePressed, // Ajout du callback dans le constructeur
  });

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
              // Section utilisateur (nom et avatar)
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

              // Corps du post
              Text(
                post.body,
                style: const TextStyle(fontSize: 16.0),
              ),

              // Image du post (si elle existe)
              if (post.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.network(post.imageUrl!),
                ),
              const SizedBox(height: 16.0),

              // Section likes et commentaires
              Row(
                children: [
                  // Bouton like
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: onLikePressed, // Utilisation du callback pour gérer les likes
                  ),
                  Text('${post.likes} likes'), // Affichage du nombre de likes

                  const SizedBox(width: 16.0),

                  // Bouton commentaire
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      // Naviguer vers l'écran de détails du post pour voir les commentaires
                      onTap();
                    },
                  ),
                  Text('${post.comments.length} commentaires'), // Affichage du nombre de commentaires
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}