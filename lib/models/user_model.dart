import 'package:belajarfirebase/models/storyuser_model.dart';

class UserModel {
  String? _uid;
  String? _username;
  String? _email;
  String? _photoUrl;
  List<StoryUser>? _storyUser;

  UserModel(String? uid, String? username, String? email, String? photoUrl,
      [List<StoryUser>? storyUser])
      : _uid = uid,
        _username = username,
        _email = email,
        _photoUrl = photoUrl,
        _storyUser = storyUser;

  String? get uid => _uid;
  String? get username => _username;
  String? get email => _email;
  String? get photoUrl => _photoUrl;
  List<StoryUser>? get storyUser => _storyUser;

  factory UserModel.fromJson(var json) {
    return UserModel(
      json["uid"],
      json["username"],
      json["email"],
      json["photoUrl"],
    );
  }

  static Map<String, dynamic> toJson(UserModel user) {
    return {
      "uid": user.uid,
      "username": user.username,
      "email": user.email,
      "photoUrl": user.photoUrl
    };
  }
}
