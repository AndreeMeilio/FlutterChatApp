import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/services/users_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UsersService _usersService = UsersService();
  final AuthService _authService = AuthService();

  UserModel currentUserModel = UserModel("", "", "", "");
  List<UserModel?> listStoriesUser = [];

  UserProvider() {
    if (_authService.getCurrentUserLoginId().isNotEmpty) {
      initCurrentUserModel();
    }
    listUserStories();
  }

  void initCurrentUserModel() async {
    currentUserModel = await _authService.getCurrentUserModel();

    notifyListeners();
  }

  void resetCurrentUserModel() {
    currentUserModel = UserModel("", "", "", "");

    notifyListeners();
  }

  Stream<List<UserModel>> get listUser {
    return _usersService.userCollection
        .where("uid", isNotEqualTo: _authService.getCurrentUserLoginId())
        .snapshots()
        .map(
          (value) => _usersService.userModelFromSnapshot(value),
        );
  }

  Future<void> listUserStories() async {
    listStoriesUser.clear();
    final QuerySnapshot users = await _usersService.userCollection.get();

    users.docs.forEach((element) async {
      final QuerySnapshot storiesUser =
          await element.reference.collection("stories").get();
      if (storiesUser.docs.isNotEmpty) {
        // final storiesUserNotExpired = storiesUser.docs.where((element) {
        //   dynamic docStoriesUser = element.data();
        // });
        notifyListeners();
      }
    });
  }
}
