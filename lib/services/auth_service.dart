import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/services/users_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  final UsersService _usersService = UsersService();

  FirebaseAuth get auth => _auth;

  UserModel? userFromCredential(User? user) {
    return user != null
        ? UserModel(user.uid, user.displayName, user.email, user.photoURL)
        : null;
  }

  //get current user sign in
  String getCurrentUserLoginId() {
    final dataCurrentUser = _auth.currentUser;
    return dataCurrentUser?.uid ?? "";
  }

  Future<UserModel> getCurrentUserModel() async {
    final userModel =
        await _usersService.userCollection.doc(_auth.currentUser?.uid).get();

    return UserModel(userModel["uid"], userModel["username"],
        userModel["email"], userModel["photoUrl"]);
  }

  //Sign in Anonymously
  Future signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      _usersService.isNewUser(userCredential.user);

      return userFromCredential(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign up akun menggunakan email dan password
  Future<UserModel?> signUp(
      {required String email,
      required String password,
      required String confirmPassword}) async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        await _auth.currentUser?.sendEmailVerification();

        return userFromCredential(userCredential.user);
      } catch (e) {
        print("di sign up error : ${e.toString()}");
        return null;
      }
    } else {
      return null;
    }
  }

  //Sign in using email and password
  Future<UserModel?> signInUsingEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      _usersService.isNewUser(user);

      return userFromCredential(user);
    } catch (e) {
      print("di sign in email password error : ${e.toString()}");
      return null;
    }
  }

  //Sign in using google
  Future<UserModel?> signInUsingGoogle() async {
    try {
      final GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
      if (_signInAccount != null) {
        final GoogleSignInAuthentication _signInAuth =
            await _signInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: _signInAuth.idToken, accessToken: _signInAuth.accessToken);

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? dataUser = userCredential.user;

        _usersService.isNewUser(userCredential.user);
        return userFromCredential(dataUser);
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print("di sign in google error: ${e.code}");
      return null;
    }
  }

  //Sign in using facebook
  Future<UserCredential?> signInUsingFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      // final String token = result.accessToken?.token ?? "";
      const String token =
          "EAAG1ZAX2cZCJUBAAk7iqBSwf6QQyLpZBEf4nRvMZC0xdss2z7aCUA3YEIx980N5971b2S3Y9JZCtZBlhPivRcSRk7wCzNe39JLbW851kh54ZBq9X8govOcn6MZA7uVp8ks3SBdwyWwZCjGZAdECtSO84xZAcl2XHp0BR2baLBjjzlZAsXo0rrFCf1j0hrwoCVM1a0oYo84XxZCgWu2QZDZD";
      if (token.isNotEmpty) {
        final AuthCredential credential =
            FacebookAuthProvider.credential(token);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return userCredential;
      } else {
        print("login gagal");
        return null;
      }
    } catch (e) {
      print("di sign in facebook error: $e");
      return null;
    }
  }

  //Sign Out User
  Future signOutUser() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // //Set preference user
  // Future<void> setPreferenceUser(UserModel user) async {
  //   final sharedPreference = await SharedPreferences.getInstance();
  //   sharedPreference.setString("uid", user.uid ?? "");
  //   sharedPreference.setString("username", user.username ?? "");
  //   sharedPreference.setString("email", user.email ?? "");
  //   sharedPreference.setString("photoUrl", user.photoUrl ?? "");
  // }
  //
  // //get user preference / user data login
  // Future<UserModel> getPreferenceUser() async {
  //   final sharedPreference = await SharedPreferences.getInstance();
  //
  //   return UserModel(
  //     sharedPreference.getString("uid"),
  //     sharedPreference.getString("username"),
  //     sharedPreference.getString("email"),
  //     sharedPreference.getString("photoUrl"),
  //   );
  // }
}
