import 'package:pixsy/features/authentication/domain/app_user.dart';

class ProfileUser extends Appuser {
  final String? bio;
  final String? profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser(
      {required super.email,
      required super.uid,
      required super.name,
      required this.bio,
      required this.profileImageUrl,
      required this.followers,
      required this.following});

  ProfileUser copywith(
      {String? newBio,
      String? newProfileImageUrl,
      List<String>? newFollowers,
      List<String>? newFollowing}) {
    return ProfileUser(
        email: email,
        uid: uid,
        name: name,
        bio: newBio ?? bio,
        profileImageUrl: newProfileImageUrl ?? profileImageUrl,
        followers: newFollowers ?? followers,
        following: newFollowing ?? following);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': uid,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        email: json['email'],
        uid: json['uid'],
        name: json['name'],
        bio: json['bio'],
        profileImageUrl: json['profileImageUrl'],
        followers: List<String>.from(json['followers'] ?? []),
        following: List<String>.from(json['following'] ?? []));
  }
}
