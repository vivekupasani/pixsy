import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/home/presentation/components/my_drawer.dart';
import 'package:pixsy/features/posts/presentation/component/post_tile.dart';
import 'package:pixsy/features/posts/presentation/cubit/post_cubit.dart';
import 'package:pixsy/features/posts/presentation/upload_post_page.dart';
import 'package:pixsy/features/profile/presentation/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PostCubit postCubit;

  @override
  void initState() {
    super.initState();
    // Initialize the PostCubit by reading it from the context
    postCubit = context.read<PostCubit>();
    fetchPost();
  }

  void fetchPost() {
    // Fetch all posts using the PostCubit
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    // Delete a post and refresh the list
    postCubit.deletePost(postId);
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: const Text("H O M E"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the UploadPostPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadPostPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state is PostError) {
              // Show an error message (e.g., a snackbar)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is PostLoading) {
              // Show a loading indicator while the posts are loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PostLoaded) {
              // Display the list of posts if loading was successful
              final allPosts = state.posts;

              if (allPosts.isEmpty) {
                // Display a message if no posts are available
                return const Center(
                  child: Text("No posts available"),
                );
              }

              return ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allPosts.length,
                    itemBuilder: (context, index) {
                      final post = allPosts[index];
                      return PostTile(
                        post: post,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(uid: post.userId),
                            )),
                        onDelete: () => deletePost(post.id),
                      );
                    },
                  )
                ],
              );
            } else if (state is PostError) {
              // Display an error message if there was an issue loading the posts
              return const Center(
                child: Text("Failed to load posts"),
              );
            }

            // Handle any unexpected states
            return const Center(
              child: Text("Unexpected state"),
            );
          },
        ),
      ),
    );
  }
}
