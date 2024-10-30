import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixsy/features/posts/domain/comment.dart';
import 'package:pixsy/features/posts/domain/post.dart';
import 'package:pixsy/features/posts/domain/post_repo.dart';
import 'package:pixsy/features/storage/domain/storage_repo.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostRepo postRepo;
  StorageRepo storageRepo;
  PostCubit(this.postRepo, this.storageRepo) : super(PostInitial());

  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      } else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      final newPost = post.copyWith(imageUrl: imageUrl);

      await postRepo.createPost(newPost);

      fetchAllPosts();
    } catch (e) {
      emit(PostError('Failed to create post: $e'));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError('Failed to fetch posts: $e'));
    }
  }

   Future<void> fetchAllPostsByUserId(String uid) async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchPostsByUserId(uid);
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError('Failed to fetch posts: $e'));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError('Failed to delete post: $e'));
    }
  }

  Future<void> toggleLikes(String postId, String userId) async {
    try {
      postRepo.toggleLike(postId, userId);
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostError('Failed to add comment: $e')); // Corrected error message
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);  

      await fetchAllPosts();
    } catch (e) {
      emit(PostError('Failed to delete comment: $e'));
    }
  }
}
