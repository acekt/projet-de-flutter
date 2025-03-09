import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/app/models/user.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/screens/create_post_screen.dart';
import 'package:frontend/app/screens/post_detail_screen.dart';
import 'package:frontend/app/controllers/post_controller.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final String token;

  const HomeScreen({super.key, required this.user, required this.token});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController());
    postController.fetchPosts(token);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              postController.fetchPosts(token); // Rafraîchir les posts
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.image ?? ''),
                    radius: 30,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                // Naviguer vers l'écran du profil
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                // Naviguer vers l'écran des paramètres
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            await postController.fetchPosts(token);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: postController.posts.length,
            itemBuilder: (context, index) {
              final post = postController.posts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 4.0,
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
                      Text(post.body, style: const TextStyle(fontSize: 14.0)),
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
                            icon: Obx(() {
                              final isLiked = postController.isPostLiked(post.id);
                              return Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: isLiked ? Colors.red : Colors.grey,
                              );
                            }),
                            onPressed: () {
                              postController.toggleLike(post.id, token);
                            },
                          ),
                          Obx(() {
                            final postLikes = postController.getPostLikes(post.id);
                            return Text('$postLikes likes', style: const TextStyle(fontSize: 14.0));
                          }),
                          const SizedBox(width: 16.0),
                          IconButton(
                            icon: const Icon(Icons.comment, color: Colors.grey),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(
                                    postId: post.id,
                                    token: token,
                                  ),
                                ),
                              );
                            },
                          ),
                          Text('${post.comments.length} commentaires', style: const TextStyle(fontSize: 14.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(
                user: user,
                token: token,
              ),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Gérer la navigation entre les pages
        },
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
    );
  }
}