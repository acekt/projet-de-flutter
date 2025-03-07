import 'package:flutter/material.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/models/user.dart';
import 'package:frontend/app/services/api_service.dart';
import 'package:frontend/app/views/widgets/post_card.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

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
      final userResponse = await apiService.get('user/${widget.userId}', token: 'YOUR_TOKEN_HERE');
      final postsResponse = await apiService.get('post?user_id=${widget.userId}', token: 'YOUR_TOKEN_HERE');

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
            const Text(
              'Posts',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            ..._posts.map((post) {
              return PostCard(
                post: post,
                onTap: () {
                  // Naviguer vers l'écran de détails du post
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}