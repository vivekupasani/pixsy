// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pixsy/features/posts/domain/comment.dart';
import 'package:pixsy/features/posts/domain/post.dart';
import 'package:pixsy/features/posts/domain/post_repo.dart';

class PostFirebaseRepo extends PostRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> createPost(Post post) async {
    try {
      await firestore.collection("posts").doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot = await firestore
          .collection("posts")
          .orderBy("timestamp", descending: true)
          .get();

      final List<Post> allPost = postsSnapshot.docs
          .map(
            (e) => Post.fromJson(e.data() as Map<String, dynamic>),
          )
          .toList();

      return allPost;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      final postsSnapshot = await firestore
          .collection("posts")
          .where("userId", isEqualTo: userId)
          .orderBy("timestamp", descending: true)
          .get();

      if (postsSnapshot.docs.isEmpty) {
        print('No posts found');
      }

      final List<Post> allPost = postsSnapshot.docs.map((e) {
        return Post.fromJson(e.data() as Map<String, dynamic>);
      }).toList();

      return allPost;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<void> toggleLike(String postId, String userId) async {
    try {
      //get the post doc
      final postSDoc = await firestore.collection("posts").doc(postId).get();

      if (postSDoc.exists) {
        // Convert the document to a Post object
        final post = Post.fromJson(postSDoc.data() as Map<String, dynamic>);

        final hasLiked = post.likes.contains(userId);

        if (hasLiked) {
          post.likes.remove(userId); //unlike post
        } else {
          post.likes.add(userId); //like post
        }

        //update the likes into database
        await firestore
            .collection("posts")
            .doc(postId)
            .update({"likes": post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    final postDoc = await firestore.collection("posts").doc(postId).get();

    try {
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        post.comments.add(comment);

        firestore.collection("posts").doc(postId).update({
          "comments": post.comments
              .map(
                (comment) => comment.toJson(),
              )
              .toList()
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding commnet $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    final postDoc = await firestore.collection("posts").doc(postId).get();

    try {
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        post.comments.removeWhere(
          (element) => element.id == commentId,
        );

        firestore.collection("posts").doc(postId).update({
          "comments": post.comments
              .map(
                (comment) => comment.toJson(),
              )
              .toList()
        });
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error deleting commnet $e");
    }
  }
}
