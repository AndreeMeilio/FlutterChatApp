import 'dart:io';

import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/components/loading_component.dart';
import 'package:belajarfirebase/components/scaffoldmessage_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/services/users_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key, required this.userModel}) : super(key: key);

  final AuthService _auth = AuthService();
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        auth: _auth,
        showAction: false,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: ColorsSetting.secondaryColor,
            boxShadow: [
              BoxShadow(
                  color: ColorsSetting.shadowColor,
                  blurRadius: 25,
                  spreadRadius: 3)
            ],
          ),
          child: ProfileContent(
            user: userModel,
          ),
        ),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key, required this.user}) : super(key: key);

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: Image.network(user?.photoUrl ??
                              "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
                          .image),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  shadowColor: ColorsSetting.shadowColor,
                  primary: ColorsSetting.secondaryColor,
                  elevation: 10,
                  side: BorderSide(
                    color: ColorsSetting.shadowColor,
                    width: 2,
                  ),
                ),
                onPressed: () async {
                  File file = await UsersService().chooseFile();

                  if (file.existsSync()) {
                    LoadingComponent.showLoadingComponent(context);
                    await UsersService().updateProfileUser(user, file);
                    Navigator.pop(context);
                    ScaffoldMessageComponent.showScaffoldComponentMessage(
                        context, "Login kembali untuk melihat perubahan");
                  }
                },
                child: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Text(
            user?.username ?? "",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Center(
          child: Text(
            user?.email ?? "",
            style: Theme.of(context).textTheme.headline2,
          ),
        )
      ],
    );
  }
}
