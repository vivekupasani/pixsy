import 'package:pixsy/features/profile/domain/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<ProfileUser?> updateUserProfile(ProfileUser updateProfile);
  Future<void> toggleFollow(String currentUid, String targetUid);
}
