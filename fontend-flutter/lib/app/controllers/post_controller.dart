import 'package:get/get.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/models/comment.dart';
import 'package:frontend/app/services/api_service.dart';

class PostController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = true.obs;
  final RxMap<int, bool> likedPosts = <int, bool>{}.obs;

  Future<void> fetchPosts(String token) async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('post', token: token);
      final List<dynamic> postsData = response['posts'];
      posts.assignAll(postsData.map((post) => Post.fromJson(post)).toList());
    } catch (e) {
      print('Erreur lors du chargement des posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPost(String body, String? imageUrl, String token) async {
    try {
      final response = await _apiService.post(
        'posts',
        {
          'body': body,
          if (imageUrl != null) 'image_url': imageUrl,
        },
        token: token,
      );

      // Ajouter le nouveau post à la liste des posts
      final newPost = Post.fromJson(response['post']);
      posts.insert(0, newPost); // Ajouter en haut de la liste
    } catch (e) {
      print('Erreur lors de la création du post: $e');
    }
  }


  Future<void> toggleLike(int postId, String token) async {
    try {
      final response = await _apiService.post(
        'posts/$postId/like',
        {},
        token: token,
      );

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
        likedPosts[postId] = !(likedPosts[postId] ?? false);
      }
    } catch (e) {
      print('Erreur lors du like: $e');
    }
  }

  bool isPostLiked(int postId) {
    return likedPosts[postId] ?? false;
  }

  int getPostLikes(int postId) {
    final post = posts.firstWhereOrNull((post) => post.id == postId);
    return post?.likes ?? 0;
  }

  Post? getPostById(int postId) {
    try {
      return posts.firstWhereOrNull((post) => post.id == postId);
    } catch (e) {
      print('Erreur lors de la récupération du post: $e');
      return null;
    }
  }

  Future<void> addComment(int postId, String commentBody, String token) async {
    try {
      final response = await _apiService.post(
        'posts/$postId/comments',
        {'body': commentBody},
        token: token,
      );

      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        // Créer une nouvelle instance de Post avec le nouveau commentaire
        final updatedPost = posts[postIndex].copyWith(
          comments: [...posts[postIndex].comments, Comment.fromJson(response['comment'])],
        );
        posts[postIndex] = updatedPost; // Mettre à jour le post dans la liste
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du commentaire: $e');
    }
  }
}