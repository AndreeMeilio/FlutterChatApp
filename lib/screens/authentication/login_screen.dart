import 'package:belajarfirebase/components/action_button_component.dart';
import 'package:belajarfirebase/components/scaffoldmessage_component.dart';
import 'package:belajarfirebase/components/text_field_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/loading_component.dart';
import '../../models/user_model.dart';
import '../../themes/color_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: SingleChildScrollView(child: LoginScreenContainer()),
      ),
    );
  }
}

class LoginScreenContainer extends StatelessWidget {
  const LoginScreenContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsSetting.shadowColor,
            spreadRadius: 5,
            blurRadius: 20,
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: FormLogin(),
    );
  }
}

class FormLogin extends StatefulWidget {
  FormLogin({Key? key}) : super(key: key);

  final AuthService auth = AuthService();

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              "Masuk",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ),
        Text(
          "Email",
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldComponent(
          label: "Masukkan Email",
          textInputType: TextInputType.emailAddress,
          textEditingController: _emailController,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Password",
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldComponent(
          label: "Masukkan Password",
          textInputType: TextInputType.visiblePassword,
          isPassword: true,
          textEditingController: _passwordController,
        ),
        const SizedBox(
          height: 25,
        ),
        Align(
          child: Consumer<UserProvider>(
            builder: (context, value, child) => ActionButtonComponent(
              label: "Masuk",
              actionButton: () async {
                LoadingComponent.showLoadingComponent(context);
                UserModel? userCredential =
                    await widget.auth.signInUsingEmailPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );

                if (userCredential != null) {
                  value.initCurrentUserModel();
                  value.listUserForAddFriend();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (_) => false);
                } else {
                  Navigator.pop(context);
                  ScaffoldMessageComponent.showScaffoldComponentMessage(
                      context, "Credential Error");
                }
              },
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "Atau",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        LoginAnonymouslyButton(),
        LoginWithGoggleButton(),
        LoginWithFacebookButton(),
        RichText(
          text: TextSpan(
            text: "Buat akun baru click ",
            style: Theme.of(context).textTheme.bodyText2,
            children: [
              TextSpan(
                text: "Di sini",
                style: Theme.of(context).textTheme.bodyText1,
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      Navigator.pushReplacementNamed(context, "/register"),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class LoginAnonymouslyButton extends StatelessWidget {
  LoginAnonymouslyButton({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Consumer<UserProvider>(
        builder: (context, value, child) => ListTile(
          onTap: () async {
            LoadingComponent.showLoadingComponent(context);
            UserModel? userCredential = await _auth.signInAnonymously();

            if (userCredential != null) {
              value.initCurrentUserModel();
              value.listUserForAddFriend();
              Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
            } else {
              Navigator.pop(context);
              ScaffoldMessageComponent.showScaffoldComponentMessage(
                  context, "Terjadi kesalahan harap coba kembali");
            }
          },
          leading: Image.asset("assets/icon_ano.png"),
          title: Text(
            "Masuk anonymously",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}

class LoginWithGoggleButton extends StatelessWidget {
  LoginWithGoggleButton({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(color: Colors.orange[100]),
      child: Consumer<UserProvider>(
        builder: (context, value, child) => ListTile(
          onTap: () async {
            LoadingComponent.showLoadingComponent(context);
            UserModel? userCredential = await _auth.signInUsingGoogle();
            if (userCredential != null) {
              value.initCurrentUserModel();
              value.listUserForAddFriend();
              Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
            } else {
              Navigator.pop(context);
              ScaffoldMessageComponent.showScaffoldComponentMessage(
                  context, "Login dengan google gagal");
            }
          },
          leading: Image.asset("assets/icon_google.png"),
          title: Text(
            "Masuk dengan google",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}

class LoginWithFacebookButton extends StatelessWidget {
  LoginWithFacebookButton({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(color: Colors.blue[100]),
      child: Consumer<UserProvider>(
        builder: (context, value, child) => ListTile(
          onTap: () async {
            LoadingComponent.showLoadingComponent(context);
            UserCredential? userCredential = await _auth.signInUsingFacebook();

            if (userCredential != null) {
              value.initCurrentUserModel();
              value.listUserForAddFriend();
              Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
            } else {
              Navigator.pop(context);
              ScaffoldMessageComponent.showScaffoldComponentMessage(
                  context, "Login dengan facebook gagal");
            }
          },
          leading: Image.asset("assets/icon_facebook.png"),
          title: Text(
            "Masuk dengan facebook",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
