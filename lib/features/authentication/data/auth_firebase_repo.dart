// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixsy/features/authentication/domain/app_user.dart';
import 'package:pixsy/features/authentication/domain/auth_repo.dart';

class AuthFirebaseRepo extends AuthRepo {
  //Firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> SignOut() async {
    await auth.signOut();
  }

  @override
  Future<Appuser?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final userDoc = await firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      String name = userDoc.data()?['name'] ?? '';

      return Appuser(email: email, name: name, uid: userCredential.user!.uid);
    } catch (e) {
      throw Exception("Login failed. $e");
    }
  }

  @override
  Future<Appuser?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        Appuser user =
            Appuser(email: email, name: name, uid: userCredential.user!.uid);

        await firestore
            .collection("users")
            .doc(user.uid)
            .set(Appuser.toJson(user));

        return user;
      }
    } catch (e) {
      throw Exception("Registration failed.  $e");
    }
    return null;
  }

  @override
  Future<Appuser?> getCurrentUser() async {
    final firebaseUser = auth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    final userDoc =
        await firestore.collection("users").doc(firebaseUser.uid).get();

    String name = userDoc.data()?['name'] ?? '';

    return Appuser(
        email: firebaseUser.email ?? '', name: name, uid: firebaseUser.uid);
  }
}
