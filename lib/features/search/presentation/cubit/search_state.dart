part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<ProfileUser?> user;

  SearchLoaded({required this.user});
}

final class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}
