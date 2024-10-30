import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pixsy/features/authentication/domain/app_user.dart';
import 'package:pixsy/features/authentication/presentation/components/my_textfield.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/features/posts/domain/comment.dart';
import 'package:pixsy/features/posts/domain/post.dart';
import 'package:pixsy/features/posts/presentation/component/comment_tile.dart';
import 'package:pixsy/features/posts/presentation/cubit/post_cubit.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';
import 'package:pixsy/features/profile/presentation/cubit/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final Function()? onDelete;
  final void Function()? onTap;

  PostTile(
      {super.key,
      required this.post,
      required this.onDelete,
      required this.onTap});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  Appuser? currentUser;
  bool isOwnPost = false;
  late final authCubit = context.read<AuthenticationCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late final postCubit = context.read<PostCubit>();
  ProfileUser? postUser;

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

//get current user
  void getCurrentUser() {
    currentUser = authCubit.currentuser;
    isOwnPost = widget.post.userId == currentUser?.uid; // Added null check
  }

//fetch user details of post user
  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

//show option to delete post
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete?.call();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

//like toggle
  void toggleLikes() {
    bool isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit.toggleLikes(widget.post.id, currentUser!.uid).catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

//add comment on the post
  void addComment() {
    if (commentController.text.isNotEmpty) {
      final newComment = Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          postId: widget.post.id,
          userId: currentUser!.uid,
          username: currentUser!.name,
          text: commentController.text,
          timestamp: DateTime.now());

      //add here
      postCubit.addComment(widget.post.id, newComment);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Write a comment...")));
    }
  }

  // Format the timestamp
  String formatTimestamp(DateTime timestamp) {
    return DateFormat('dd-MM-yyyy').format(timestamp);
  }


//dialog for comment box
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(
          "A D D  C O M M E N T",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 18),
        )),
        content: MyTextField(
            Controller: commentController,
            hint: "Write comment...",
            obscureText: false),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                commentController.clear();
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                addComment();
                commentController.clear();
              },
              child: const Text("Post"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                //profile picture
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: postUser != null
                        ? CachedNetworkImage(
                            imageUrl: postUser!.profileImageUrl.toString(),
                            imageBuilder: (context, imageProvider) => Image(
                              height: 40,
                              width: 40,
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(
                                Icons.person,
                                size: 24,
                              ),
                            ),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 32,
                          ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),

                //user name
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    widget.post.userName,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                const Spacer(),

                //delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
              ],
            ),
          ),

          //Image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            imageBuilder: (context, imageProvider) => Image(
                height: 420, width: double.infinity, image: imageProvider),
            errorWidget: (context, url, error) => const SizedBox(
              height: 420,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            placeholder: (context, url) => const SizedBox(
              height: 420,
              width: double.infinity,
              child: Center(
                child: Icon(
                  Icons.error,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),

          //Like - Comment - timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                //likes button and count
                SizedBox(
                    width: 45,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: toggleLikes,
                          child: Icon(
                            widget.post.likes.contains(currentUser!.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.post.likes.contains(currentUser!.uid)
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.post.likes.length.toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    )),

                //comment
                SizedBox(
                    width: 45,
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: showCommentDialog,
                            child: Icon(
                              Icons.comment,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.post.comments.length.toString(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        )
                      ],
                    )),
                const Spacer(),
                //TimeStamp
                Text(
                  formatTimestamp(widget.post.timestamp),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),

          //username and caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.userName,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    widget.post.text,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),

          //comments
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoaded) {
                final posts = state.posts.firstWhere(
                  (post) => post.id == widget.post.id,
                );

                if (posts.comments.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        posts.comments.length > 3 ? 3 : posts.comments.length,
                    itemBuilder: (context, index) {
                      final comments = posts.comments[index];

                      return CommentTile(comment: comments);
                    },
                  );
                }
              }

              return const SizedBox();
            },
          ),

          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }
}
