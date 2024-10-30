part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final Appuser user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}

class AuthError extends AuthenticationState {
  final String message;
  AuthError({required this.message});
}