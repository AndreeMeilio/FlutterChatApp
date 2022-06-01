import 'package:belajarfirebase/models/storyuser_model.dart';
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

  void resetDataStoriesUser() {
    listStoriesUser = [];

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
    final QuerySnapshot users =
        await _usersService.userCollection.orderBy("uid").get();

    users.docs.forEach((element) async {
      dynamic dataUser = element.data();

      final QuerySnapshot storiesUser =
          await element.reference.collection("stories").get();
      if (storiesUser.docs.isNotEmpty) {
        List<StoryUserModel>? dataStoriesUser = [];

        storiesUser.docs.forEach((storyElement) {
          dynamic dataStoryElement = storyElement.data();
          DateTime postTime =
              DateTime.parse(dataStoryElement["postTime"].toDate().toString());
          DateTime nowTime = DateTime.now();

          if (nowTime.difference(postTime).inHours <= 24) {
            dataStoriesUser.add(StoryUserModel(
                caption: dataStoryElement["caption"],
                urlFile: dataStoryElement["urlFile"],
                namaFile: dataStoryElement["namaFile"],
                postTime: postTime,
                views: dataStoryElement["views"]));
          }
        });

        UserModel result = UserModel(dataUser["uid"], dataUser["username"],
            dataUser["email"], dataUser["photoUrl"], dataStoriesUser);

        if (element.id == _authService.getCurrentUserLoginId()) {
          listStoriesUser.insert(
            0,
            result,
          );
        } else {
          listStoriesUser.add(result);
        }
        notifyListeners();
      }
    });
  }
}
