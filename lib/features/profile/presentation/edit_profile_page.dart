import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/presentation/components/my_textfield.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';
import 'package:pixsy/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:pixsy/responsive/scaffold_responsive.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //picked file
  PlatformFile? imagepickedFile;

  //web image picked
  Uint8List? webImage;

  //bio controller
  final bioController = TextEditingController();

  //profile cubit
  late final ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    profileCubit = context.read<ProfileCubit>();
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  void pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: kIsWeb);

    if (result != null) {
      setState(() {
        imagepickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagepickedFile!.bytes;
        }
      });
    }
  }

  void editProfile() async {
    final mobileImagePath = kIsWeb ? null : imagepickedFile?.path;
    final webImageByte = kIsWeb ? imagepickedFile?.bytes : null;

    // Use the existing bio if the text field is empty
    final updatedBio =
        bioController.text.isNotEmpty ? bioController.text : widget.user.bio;

    if (updatedBio != null || imagepickedFile != null) {
      profileCubit.updateUserProfile(
          widget.user.uid, updatedBio!, mobileImagePath, webImageByte);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Updating...")
                ],
              ),
            ),
          );
        }
        return ScaffoldResponsive(
          appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.primary,
            title: const Text("Edit Profile"),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: editProfile,
                icon: const Icon(Icons.upload),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //profile image
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child:
                      //image mobile
                      (!kIsWeb && imagepickedFile != null)
                          ? Image.file(File(imagepickedFile!.path!))
                          //image web
                          : (kIsWeb && imagepickedFile != null)
                              ? Image.memory(webImage!)
                              //no image selected
                              : CachedNetworkImage(
                                  imageUrl:
                                      widget.user.profileImageUrl.toString(),

                                  //loading
                                  placeholder: (context, url) => Container(
                                    height: 150,
                                    width: 150,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        shape: BoxShape.circle),
                                    child: const CircularProgressIndicator(),
                                  ),

                                  //error
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 150,
                                    width: 150,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.person,
                                      size: 72,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),

                                  //loaded
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                          height: 150,
                                          width: 150,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              shape: BoxShape.circle),
                                          child: Image(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                ),
                ),

                const SizedBox(
                  height: 10,
                ),

                //pick image button
                MaterialButton(
                  onPressed: pickImage,
                  color: Colors.blue,
                  child: const Text("Pick Image"),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Bio
                Text(
                  "Bio",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                // Bio Text Field
                MyTextField(
                  Controller: bioController,
                  hint: widget.user.bio != null
                      ? widget.user.bio.toString()
                      : "Empty bio...",
                  obscureText: false,
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    );
  }
}
