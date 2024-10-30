

import 'package:pixsy/features/authentication/domain/app_user.dart';

abstract class AuthRepo {
  Future<Appuser?> loginWithEmailAndPassword(String email,String password);
  Future<Appuser?> registerWithEmailAndPassword(String name,String email,String password);
  Future<void>SignOut();
  Future<Appuser?>getCurrentUser();
}