import 'package:belajarfirebase/components/action_button_component.dart';
import 'package:belajarfirebase/components/loading_component.dart';
import 'package:belajarfirebase/components/scaffoldmessage_component.dart';
import 'package:belajarfirebase/components/text_field_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                    color: ColorsSetting.shadowColor,
                    spreadRadius: 5,
                    blurRadius: 25)
              ],
            ),
            margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 25),
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: FormRegister()),
      ),
    );
  }
}

class FormRegister extends StatefulWidget {
  FormRegister({Key? key}) : super(key: key);

  final AuthService auth = AuthService();

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              "Daftar",
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
          height: 15,
        ),
        Text(
          "Confirm Password",
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFieldComponent(
          label: "Masukkan Confirm Password",
          textInputType: TextInputType.visiblePassword,
          isPassword: true,
          textEditingController: _confirmPasswordController,
        ),
        const SizedBox(
          height: 25,
        ),
        Align(
          child: ActionButtonComponent(
            label: "Daftar",
            actionButton: () async {
              LoadingComponent.showLoadingComponent(context);
              final UserModel? userSignUp = await widget.auth.signUp(
                email: _emailController.text,
                password: _passwordController.text,
                confirmPassword: _confirmPasswordController.text,
              );
              if (userSignUp != null) {
                Navigator.pushReplacementNamed(context, "/login");
              } else {
                Navigator.pop(context);
                ScaffoldMessageComponent.showScaffoldComponentMessage(
                  context,
                  "Terjadi kesalahan pada user credential",
                );
              }
            },
          ),
          alignment: Alignment.centerLeft,
        ),
        RichText(
          text: TextSpan(
            text: "Sudah punya akun? lanjut ",
            style: Theme.of(context).textTheme.bodyText2,
            children: [
              TextSpan(
                text: "Login",
                style: Theme.of(context).textTheme.bodyText1,
                recognizer: TapGestureRecognizer()
                  ..onTap =
                      () => Navigator.pushReplacementNamed(context, "/login"),
              )
            ],
          ),
        )
      ],
    );
  }
}
