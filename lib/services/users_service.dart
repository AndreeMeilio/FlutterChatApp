import 'dart:io';

import 'package:belajarfirebase/models/storyuser_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UsersService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("users");

  final Reference _storage = FirebaseStorage.instance.ref();

  CollectionReference get userCollection => _userCollection;

  Future<void> isNewUser(User? user) async {
    final checkedUser =
        await _userCollection.where("uid", isEqualTo: user?.uid).get();
    if (checkedUser.docs.isEmpty) {
      final dataUser = _userCollection.doc(user?.uid).set(UserModel.toJson(
          UserModel(
              user?.uid, user?.displayName, user?.email, user?.photoURL)));
    }
  }

  //Convert snapshot data into user model
  List<UserModel> userModelFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((value) {
      final data = value.data();
      return UserModel.fromJson(data);
    }).toList();
  }

  Future<File> chooseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    return File(result?.files.single.path ?? "");
  }

  //Upload / Edit Profile User
  Future<void> updateProfileUser(UserModel? user, File file) async {
    final Reference profileRef = _storage.child("user/profile");
    final String time = DateTime.now().toString();

    try {
      final TaskSnapshot uploadPhoto =
          await profileRef.child("${user?.uid}-$time").putFile(file);
      final String downloadUrlPhoto = await uploadPhoto.ref.getDownloadURL();

      await userCollection
          .doc(user?.uid)
          .update({"photoUrl": downloadUrlPhoto});
    } catch (e, s) {
      debugPrint(
          "di error updateProfileUser: exception - $e / stacktrace - $s");
    }
  }

  Future<void> uploadStoryUser(
      UserModel? user, File file, String caption) async {
    final userStoryRef = _userCollection.doc(user?.uid).collection("stories");

    final DateTime postTime = DateTime.now();
    final String namaFile = "story${user?.uid}$postTime";

    //Upload file to storage and to collection
    final Reference storageStoryRef = _storage.child("user/story");
    try {
      final TaskSnapshot uploadStoryResult =
          await storageStoryRef.child(namaFile).putFile(file);
      final String urlFile = await uploadStoryResult.ref.getDownloadURL();

      userStoryRef.add(StoryUserModel.toJson(StoryUserModel(
          caption: caption,
          urlFile: urlFile,
          namaFile: namaFile,
          postTime: postTime)));
    } catch (e) {
      print("error di upload story user $e");
    }
  }
}
