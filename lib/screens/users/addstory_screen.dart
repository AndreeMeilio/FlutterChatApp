import 'package:belajarfirebase/components/action_button_component.dart';
import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/components/loading_component.dart';
import 'package:belajarfirebase/components/scaffoldmessage_component.dart';
import 'package:belajarfirebase/components/text_field_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/addstory_provider.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/services/users_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStoryScreen extends StatelessWidget {
  AddStoryScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBarComponent(
        auth: _auth,
        showAction: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorsSetting.secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        child: const FormAddStory(),
      ),
    );
  }
}

class FormAddStory extends StatelessWidget {
  const FormAddStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).currentUserModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            "Add Story",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            "Pilih file",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Expanded(
          child: Consumer<AddStoryProvider>(
            builder: (context, value, child) => GestureDetector(
              onTap: () async {
                await value.pickFileStory();
              },
              child: value.fileStory != null
                  ? Image.file(value.fileStory!)
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            "Caption Story",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Consumer<AddStoryProvider>(
            builder: (context, value, child) => TextFieldComponent(
              textEditingController: value.captionController,
              label: "masukkan caption untuk story",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Consumer<AddStoryProvider>(
            builder: (context, value, child) => ActionButtonComponent(
              actionButton: () async {
                if (value.captionController.text.isNotEmpty &&
                    value.fileStory != null) {
                  LoadingComponent.showLoadingComponent(context);
                  await UsersService().uploadStoryUser(
                      user, value.fileStory!, value.captionController.text);
                  Navigator.pop(context);
                  ScaffoldMessageComponent.showScaffoldComponentMessage(
                      context, "Menambah story berhasil");
                  value.captionController.clear();
                  value.fileStory = null;
                  Navigator.pop(context);
                } else {
                  ScaffoldMessageComponent.showScaffoldComponentMessage(
                      context, "Masukkan caption dan file foto");
                }
              },
              label: "Add to story",
            ),
          ),
        )
      ],
    );
  }
}
