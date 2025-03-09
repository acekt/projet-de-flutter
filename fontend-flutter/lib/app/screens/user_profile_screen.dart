import 'package:flutter/material.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/models/user.dart';
import 'package:frontend/app/screens/post_detail_screen.dart';
import 'package:frontend/app/services/api_service.dart';
import 'package:frontend/app/views/widgets/post_card.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  final String token; // Ajout du token pour les requêtes authentifiées

  const UserProfileScreen({super.key, required this.userId, required this.token});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? _user;
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final apiService = ApiService();
      final userResponse = await apiService.get('user/${widget.userId}', token: widget.token);
      final postsResponse = await apiService.get('post?user_id=${widget.userId}', token: widget.token);

      // Extrait les posts de la réponse JSON
      setState(() {
        _user = User.fromJson(userResponse['user']);
        _posts = List<Post>.from(postsResponse['posts'].map((x) => Post.fromJson(x)));
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLike(int postId) async {
    try {
      final apiService = ApiService();
      final response = await apiService.post(
        'posts/$postId/like',
        {},
        token: widget.token,
      );

      if (response['action'] == 'liked') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post liké')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Like retiré')),
        );
      }

      // Mettre à jour l'état du post après le like/unlike
      setState(() {
        final postIndex = _posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          _posts[postIndex] = Post(
            id: _posts[postIndex].id,
            body: _posts[postIndex].body,
            imageUrl: _posts[postIndex].imageUrl,
            user: _posts[postIndex].user,
            comments: _posts[postIndex].comments,
            likes: response['likes_count'],
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du like: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section profil utilisateur
            CircleAvatar(
              backgroundImage: NetworkImage(_user!.image ?? ''),
              radius: 50.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              _user!.name,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              _user!.email,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 24.0),

            // Section posts
            const Text(
              'Posts',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            ..._posts.map((post) {
              return PostCard(
                post: post,
                onTap: () {
                  // Naviguer vers l'écran de détails du post
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(
                        postId: post.id,
                        token: widget.token,
                      ),
                    ),
                  );
                },
                onLikePressed: () {
                  // Gérer le like
                  _toggleLike(post.id);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}