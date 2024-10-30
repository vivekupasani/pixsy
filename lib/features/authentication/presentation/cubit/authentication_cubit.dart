import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixsy/features/authentication/domain/app_user.dart';
import 'package:pixsy/features/authentication/domain/auth_repo.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthRepo authRepo;
  Appuser? _currentUser;

  AuthenticationCubit(this.authRepo) : super(AuthenticationInitial());

  //check if user already authenticated
  void checkAuth() async {
    final Appuser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  //currentuser
  Appuser? get currentuser => _currentUser;

  //login with email and password
  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());

      final user = await authRepo.loginWithEmailAndPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());

      final user =
          await authRepo.registerWithEmailAndPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    await authRepo.SignOut();
    emit(Unauthenticated());
  }
}
