import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/domain/app_user.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/features/posts/presentation/component/post_tile.dart';
import 'package:pixsy/features/posts/presentation/cubit/post_cubit.dart';
import 'package:pixsy/features/profile/presentation/components/follow_unfollow_btn.dart';
import 'package:pixsy/features/profile/presentation/components/profile_stats.dart';
import 'package:pixsy/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:pixsy/features/profile/presentation/edit_profile_page.dart';
import 'package:pixsy/features/profile/presentation/follower_page.dart';
import 'package:pixsy/responsive/scaffold_responsive.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthenticationCubit authCubit =
      context.read<AuthenticationCubit>();
  late final ProfileCubit profileCubit = context.read<ProfileCubit>();

  late Appuser? currentUser = authCubit.currentuser;
  late bool isOwnPost;
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.uid);
    isOwnPost = widget.uid == currentUser?.uid; 
  }

  void deletePost(String postId) {
    final postCubit = context.read<PostCubit>();
    postCubit.deletePost(postId);
    postCubit.fetchAllPosts();
  }

  void toggleFollow() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }

    final profileUser = profileState.user;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        if (isFollowing) {
          profileUser.followers.remove(currentUser!.uid);
        } else {
          profileUser.followers.add(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading profile: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileLoaded) {
          final user = state.user;

          // Calculate the post count
          final postCubit = context.read<PostCubit>();
          final posts = postCubit.state is PostLoaded
              ? (postCubit.state as PostLoaded)
                  .posts
                  .where((post) => post.userId == widget.uid)
                  .toList()
              : [];
          postCount = posts.length; // Store the post count

          return ScaffoldResponsive(
            appBar: AppBar(
              centerTitle: true,
              foregroundColor: Theme.of(context).colorScheme.primary,
              title: Text(user.name),
              actions: [
                if (isOwnPost)
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                  ),
              ],
            ),
            body: ListView(
              children: [
                // User email
                Center(
                  child: Text(
                    user.email,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),

                // User profile picture
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl.toString(),
                  placeholder: (context, url) => Container(
                    height: 150,
                    width: 150,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    width: 150,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 150,
                    width: 150,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: BoxShape.circle,
                    ),
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Profile stats displayed here
                ProfileStats(
                  postCount: postCount.toString(),
                  followerCount: user.followers.length.toString(),
                  followingCount: user.following.length.toString(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowerPage(
                          followers: user.followers,
                          following: user.following,
                          username: user.name,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // Follow or unfollow button
                if (!isOwnPost)
                  FollowUnfollowBtn(
                    isFollowing: user.followers.contains(currentUser!.uid),
                    onPressed: toggleFollow,
                  ),
                if (!isOwnPost) const SizedBox(height: 18),

                // Bio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bio Box
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 26.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (user.bio!.isNotEmpty)
                          ? user.bio.toString()
                          : "Empty bio...",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),

                // Posts section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading || state is PostUploading) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Loading..."),
                          ],
                        ),
                      );
                    }
                    if (state is PostLoaded) {
                      final posts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();

                      if (posts.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Center(
                            child: Text(
                              "No posts available",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final eachPost = posts[index];

                          return PostTile(
                            post: eachPost,
                            onDelete: () => deletePost(eachPost.id),
                            onTap: () {},
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          );
        }

        if (state is ProfileError) {
          return const Scaffold(
            body: Center(child: Text("Failed to load user profile")),
          );
        }

        return const Scaffold(
          body: Center(child: Text("USER NOT FOUND")),
        );
      },
    );
  }
}
