import 'package:flutter/material.dart';
import 'package:frontend/app/models/user.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/services/api_service.dart';
import 'package:frontend/app/screens/create_post_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final String token;

  const HomeScreen({super.key, required this.user, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Post> posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final apiService = ApiService();
      final response = await apiService.get('post', token: widget.token);

      // Affichez la réponse JSON pour vérifier sa structure
      print('Réponse JSON: $response');

      // Extrait la liste des posts de la réponse JSON
      final Map<String, dynamic> jsonData = response;
      final List<dynamic> postsData = jsonData['posts'];

      setState(() {
        posts = postsData.map((post) => Post.fromJson(post)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des posts: $e')),
      );
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

      // Mettez à jour l'état du post après le like/unlike
      setState(() {
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex] = Post(
            id: posts[postIndex].id,
            body: posts[postIndex].body,
            imageUrl: posts[postIndex].imageUrl,
            user: posts[postIndex].user,
            comments: posts[postIndex].comments,
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(
                user: widget.user,
                token: widget.token,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  final List<Widget> _pages = [
    const HomeContent(),
    const NotificationsPage(),
    const ProfilePage(),
  ];
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = (context.findAncestorStateOfType<_HomeScreenState>()?.posts ?? []);

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
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
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(post.body),
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 8.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(post.imageUrl!),
                  ),
                ],
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // Logique pour liker un post
                        final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                        if (homeState != null) {
                          homeState._toggleLike(post.id);
                        }
                      },
                    ),
                    Text('${post.likes} likes'),
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/post-detail',
                          arguments: post.id,
                        );
                      },
                    ),
                    Text('${post.comments.length} commentaires'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Notifications',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (context.findAncestorStateOfType<_HomeScreenState>()?.widget.user);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user?.image ?? ''),
          ),
          const SizedBox(height: 16.0),
          Text(
            user?.name ?? 'Utilisateur',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}