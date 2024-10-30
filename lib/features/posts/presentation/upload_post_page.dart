// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/domain/app_user.dart';
import 'package:pixsy/features/authentication/presentation/components/my_textfield.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/features/posts/domain/post.dart';
import 'package:pixsy/features/posts/presentation/cubit/post_cubit.dart';
import 'package:pixsy/responsive/scaffold_responsive.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // Mobile image
  PlatformFile? imagePicked;

  // Web image
  Uint8List? webImage;

  final captionController = TextEditingController();
  Appuser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthenticationCubit>();
    currentUser = authCubit.currentuser;
  }

  void pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagePicked = result.files.first;

        if (kIsWeb) {
          webImage = imagePicked!.bytes;
        }
      });
    }
  }

  void uploadPost() async {
    if (imagePicked == null || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Caption and image both are required")),
      );
      return;
    }

    final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: captionController.text.trim(),
        imageUrl: '',
        timestamp: DateTime.now(),
        likes: [],
        comments: []);

    final postCubit = context.read<PostCubit>();

    if (kIsWeb) {
      await postCubit.createPost(newPost, imageBytes: webImage);
    } else {
      await postCubit.createPost(newPost, imagePath: imagePicked!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Uploading...")
                ],
              ),
            ),
          );
        }

        return buildUploadPage();
      },
      listener: (context, state) {
        if (state is PostLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Post uploaded successfully!")),
          );
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return ScaffoldResponsive(
      appBar: AppBar(
        title: const Text("Create Post"),
        centerTitle: true,
        actions: [
          // Upload post button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: uploadPost,
              child: const Icon(Icons.upload),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Show selected image (web or mobile)
                if (kIsWeb && webImage != null)
                  Image.memory(
                    webImage!,
                    height: 420,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                if (!kIsWeb && imagePicked != null)
                  Image.file(
                    File(imagePicked!.path!),
                    height: 420,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                const SizedBox(height: 16.0),

                // Pick an image button
                MaterialButton(
                  onPressed: pickImage,
                  color: Colors.blue,
                  child: const Text("Pick Image",
                      style: TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 16.0),

                // Caption text field
                MyTextField(
                  Controller: captionController,
                  hint: "Caption...",
                  obscureText: false,
                ),

                const SizedBox(height: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
