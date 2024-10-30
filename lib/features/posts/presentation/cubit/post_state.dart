part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostUploading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded({required this.posts});
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class CommentLoading extends PostState {}

class CommentLoaded extends PostState {
  final List<Comment> comments;

  CommentLoaded(this.comments);
}
