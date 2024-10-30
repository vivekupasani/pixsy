import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixsy/features/profile/data/profile_firebase_repo.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';
import 'package:pixsy/features/storage/data/storage_firebase_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileFirebaseRepo profileRepo;
  final StorageFirebaseRepo storageRepo;

  ProfileCubit(this.profileRepo, this.storageRepo) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        emit(ProfileError(message: 'User not found'));
      }
    } catch (e) {
      emit(ProfileError(
          message: 'Error fetching user profile: ${e.toString()}'));
    }
  }

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    if (user != null) {
      return user;
    }
    return null;
  }

  Future<void> updateUserProfile(
    String uid,
    String? newBio,
    String? uploadProfileMobile,
    Uint8List? uploadProfileWeb,
  ) async {
    try {
      emit(ProfileLoading());

      // Fetch current user profile
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError(message: "Failed to fetch user for update"));
        return;
      }

      // Variable to hold the new profile image URL
      String? newProfileImageUrl;

      // Update profile image if a new one is provided
      if (uploadProfileMobile != null || uploadProfileWeb != null) {
        // Mobile upload
        if (uploadProfileMobile != null) {
          newProfileImageUrl = await storageRepo.uploadProfileImageMobile(
            uploadProfileMobile,
            uid,
          );
        }
        // Web upload
        else if (uploadProfileWeb != null) {
          newProfileImageUrl = await storageRepo.uploadProfileImageWeb(
            uploadProfileWeb,
            uid,
          );
        }

        // If image upload failed, emit an error state
        if (newProfileImageUrl == null) {
          emit(ProfileError(message: "Failed to upload image"));
          return;
        }
      }

      // Update bio and profile image URL if available
      final updatedProfile = currentUser.copywith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: newProfileImageUrl ?? currentUser.profileImageUrl,
      );

      // Update the profile in Firestore
      await profileRepo.updateUserProfile(updatedProfile);

      emit(ProfileLoaded(user: updatedProfile));
    } catch (e) {
      emit(ProfileError(message: 'Error updating profile: ${e.toString()}'));
    }
  }

  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      profileRepo.toggleFollow(currentUid, targetUid);

      // await fetchUserProfile(targetUid);
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
