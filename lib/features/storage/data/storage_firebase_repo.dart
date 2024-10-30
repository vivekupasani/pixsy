// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pixsy/features/storage/domain/storage_repo.dart';

class StorageFirebaseRepo extends StorageRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) async {
    try {
      final file = File(path);

      final storageRef = storage.ref().child("profile_images/$fileName");

      final uploadTask = await storageRef.putFile(file);

      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadProfileImageWeb(
      Uint8List bytes, String fileName) async {
    try {
      final storageRef = storage.ref().child("profile_images/$fileName");


      final uploadTask = await storageRef.putData(bytes);

      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) async{
    try{
      final file = File(path);

      final storageRef = storage.ref().child("posts_images/$fileName");

      // ignore: non_constant_identifier_names
      final UploadTask = await storageRef.putFile(file);

      final downloadFile =await storageRef.getDownloadURL();

      return downloadFile;
    }
    catch(e){}
    return null;
  }
  
  @override
  Future<String?> uploadPostImageWeb(Uint8List bytes, String fileName)async {

    final storageRef = storage.ref().child("posts_images/$fileName");

      final UploadTask = await storageRef.putData(bytes);

      final downloadFile =await storageRef.getDownloadURL();

      return downloadFile;
  }
}
