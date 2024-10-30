import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pixsy/features/profile/domain/profile_repo.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';

class ProfileFirebaseRepo extends ProfileRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final user = userDoc.data();
        if (user != null) {
          final followers = List<String>.from(user['followers'] ?? []);
          final following = List<String>.from(user['following'] ?? []);

          return ProfileUser(
            email: user['email'] ?? '',
            uid: user['uid'] ?? '',
            name: user['name'] ?? '',
            bio: user['bio'] ?? '',
            profileImageUrl: user['profileImageUrl'] ?? '',
            followers: followers,
            following: following,
          );
        }
      }
    } catch (e) {
      throw Exception("Error fetching user profile: $e");
    }
    return null;
  }

  @override
  Future<ProfileUser?> updateUserProfile(ProfileUser updateProfile) async {
    try {
      await firestore.collection('users').doc(updateProfile.uid).update({
        'bio': updateProfile.bio,
        'profileImageUrl': updateProfile.profileImageUrl,
        'name': updateProfile.name,
        'email': updateProfile.email,
      });

      // Return the updated profile to confirm the changes
      return await fetchUserProfile(updateProfile.uid);
    } catch (e) {
      throw Exception("Error updating profile: $e");
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    // fetch current user and target user documents
    final currentUserDoc =
        await firestore.collection("users").doc(currentUid).get();
    final targetUserDoc =
        await firestore.collection("users").doc(targetUid).get();

    if (currentUserDoc.exists && targetUserDoc.exists) {
      // current and target user data
      final currentUserData = currentUserDoc.data();

      // fetch following list of current user
      List<String> currentFollowing =
          List<String>.from(currentUserData!['following'] ?? []);

      // check if current user is following the target user
      if (currentFollowing.contains(targetUid)) {
        // unfollow
        await firestore.collection("users").doc(currentUid).update({
          'following': FieldValue.arrayRemove([targetUid])
        });
        await firestore.collection("users").doc(targetUid).update({
          'followers': FieldValue.arrayRemove([currentUid])
        });
      } else {
        // follow
        await firestore.collection("users").doc(currentUid).update({
          'following': FieldValue.arrayUnion([targetUid])
        });
        await firestore.collection("users").doc(targetUid).update({
          'followers': FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }
}
