part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

//profile loading state
final class ProfileLoading extends ProfileState{}

//profile loaded 
final class ProfileLoaded extends ProfileState{
  final ProfileUser user;

  ProfileLoaded({required this.user});
}

//profile error 
final class ProfileError extends ProfileState{
  final String message;

  ProfileError({required this.message});
}
