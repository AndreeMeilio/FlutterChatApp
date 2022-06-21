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
  List<UserModel>? listForAddFriends;

  UserProvider() {
    if (_authService.getCurrentUserLoginId().isNotEmpty) {
      initCurrentUserModel();
    }
    listUserStories();
    listUserForAddFriend();
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

  Future<void> onRefreshIndicator() async {
    await listUserStories();
    await listFriendsUser(_authService.getCurrentUserLoginId());
  }

  Future<void> listUserForAddFriend({String? email}) async {
    int jumlahDataPerRequest = 10;

    if (email?.isNotEmpty ?? false) {
      QuerySnapshot collectionUser = await _usersService.userCollection
          .limit(jumlahDataPerRequest)
          .where("email", isEqualTo: email.toString())
          .where("uid", isNotEqualTo: _authService.getCurrentUserLoginId())
          .get();
      listForAddFriends = collectionUser.docs
          .map((user) => UserModel.fromJson(user.data()))
          .toList();

      notifyListeners();
    } else {
      QuerySnapshot collectionUser = await _usersService.userCollection
          .limit(jumlahDataPerRequest)
          .where("uid", isNotEqualTo: _authService.getCurrentUserLoginId())
          .get();
      listForAddFriends = collectionUser.docs
          .map((user) => UserModel.fromJson(user.data()))
          .toList();

      notifyListeners();
    }
  }

  Future<List<UserModel>> listFriendsUser(String id) async {
    DocumentSnapshot dataDocUser =
        await _usersService.userCollection.doc(id).get();
    dynamic dataUser = dataDocUser.data();
    List<dynamic> listFriendsId = dataUser["friends"];

    List<UserModel> friendsResult = [];
    if (listFriendsId.isNotEmpty) {
      await Future.forEach(listFriendsId, (element) async {
        DocumentSnapshot docUserFriend =
            await _usersService.userCollection.doc(element.toString()).get();
        friendsResult.add(UserModel.fromJson(docUserFriend.data()));
      });
    }

    return friendsResult;
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
        bool isAllStoryExpired = false;
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
        if (dataStoriesUser.isNotEmpty) {
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
        }

        notifyListeners();
      }
    });
  }
}
