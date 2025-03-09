import 'package:get/get.dart';
import 'package:frontend/app/models/post.dart';
import 'package:frontend/app/models/comment.dart';
import 'package:frontend/app/models/like.dart';
import 'package:frontend/app/services/api_service.dart';
import 'package:http/http.dart';

class PostController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = true.obs;

  Future<void> fetchPosts(String token) async {
    try {
      final response = await _apiService.get('post', token: token);
      final List<dynamic> postsData = response['posts'];
      posts.assignAll(postsData.map((post) => Post.fromJson(post)).toList());
    } catch (e) {
      print('Erreur lors du chargement des posts: $e');
    } finally {
      isLoading.value = false;
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
      }
    } catch (e) {
      print('Erreur lors du like: $e');
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
        posts[postIndex] = Post(
          id: posts[postIndex].id,
          body: posts[postIndex].body,
          imageUrl: posts[postIndex].imageUrl,
          user: posts[postIndex].user,
          comments: [...posts[postIndex].comments, Comment.fromJson(response['comment'])],
          likes: posts[postIndex].likes,
        );
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du commentaire: $e');
    }
  }

  Future<void> updateComment(int commentId, String commentBody, String token) async {
    try {
      final response = await _apiService.put(
        'comments/$commentId',
        {'body': commentBody},
        token: token,
      );

      // Mettre à jour le commentaire dans le post correspondant
      for (var post in posts) {
        final commentIndex = post.comments.indexWhere((comment) => comment.id == commentId);
        if (commentIndex != -1) {
          post.comments[commentIndex] = Comment.fromJson(response['comment']);
          break;
        }
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du commentaire: $e');
    }
  }

  Future<void> deleteComment(int commentId, String token) async {
    try {
      await _apiService.delete(
        'comments/$commentId',
        token: token,
      );

      // Supprimer le commentaire du post correspondant
      for (var post in posts) {
        post.comments.removeWhere((comment) => comment.id == commentId);
      }
    } catch (e) {
      print('Erreur lors de la suppression du commentaire: $e');
    }
  }
}