import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/services/friends_service.dart';
import 'package:belajarfirebase/services/users_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class FriendsProvider extends ChangeNotifier {
  final CollectionReference _friendsCollection =
      FriendsService().friendsCollection;
  final CollectionReference _userCollection = UsersService().userCollection;
  final AuthService _authService = AuthService();

  Stream<List<UserModel>> get getNotificationRequestFriend {
    return _friendsCollection
        .where("receiver", isEqualTo: _authService.getCurrentUserLoginId())
        .snapshots()
        .map((event) => event.docs.map((value) {
              dynamic dataUser = value.data();
              return UserModel.fromJson(dataUser["sender"]);
            }).toList());
  }
}
