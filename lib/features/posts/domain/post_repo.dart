import 'package:pixsy/features/posts/domain/comment.dart';
import 'package:pixsy/features/posts/domain/post.dart';

abstract class PostRepo {
  //fetch user posts
  Future<List<Post>> fetchAllPosts();
  Future<List<Post>> fetchPostsByUserId(String userId);

  //create and delete a post
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);

  //like a post
  Future<void> toggleLike(String postId, String userId);

  //add - delete comments
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, String commentId);
}
