import 'package:belajarfirebase/components/action_button_component.dart';
import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/components/loading_component.dart';
import 'package:belajarfirebase/components/scaffoldmessage_component.dart';
import 'package:belajarfirebase/components/text_field_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/groupchat_provider.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/services/groupchat_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroupChatScreen extends StatelessWidget {
  CreateGroupChatScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(auth: _auth, label: "Group Chat"),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorsSetting.secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        child: const FormCreateNewGroup(),
      ),
    );
  }
}

class FormCreateNewGroup extends StatefulWidget {
  const FormCreateNewGroup({Key? key}) : super(key: key);

  @override
  State<FormCreateNewGroup> createState() => _FormCreateNewGroupState();
}

class _FormCreateNewGroupState extends State<FormCreateNewGroup> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _groupNameController.dispose();
    _photoUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).currentUserModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Create New Group",
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Group Name",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFieldComponent(
            textEditingController: _groupNameController,
            label: "masukkan nama group"),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Photo Url",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFieldComponent(
            textEditingController: _photoUrlController,
            label: "masukkan photo URL group"),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Tambah Anggota",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: 5,
        ),
        const Expanded(
          flex: 4,
          child: ListUser(),
        ),
        Consumer<GroupChatProvider>(
          builder: (context, value, child) => ActionButtonComponent(
              label: "Create",
              actionButton: () async {
                value.addUserToAnggotaGroup(user.uid ?? "");
                LoadingComponent.showLoadingComponent(context);
                final createdGroup = await GroupChatService().createNewGroup(
                    _groupNameController.text,
                    _photoUrlController.text,
                    value.listAnggotaGroup);

                if (createdGroup?.id.isNotEmpty ?? false) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessageComponent.showScaffoldComponentMessage(
                      context, "Terdapat kesalahan ketika membuat group");
                }

                _groupNameController.clear();
                _photoUrlController.clear();
                value.setListAnggotaGroupToNull();
              }),
        )
      ],
    );
  }
}

class ListUser extends StatelessWidget {
  const ListUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: UserProvider().listUser,
      builder: ((context, snapshot) => ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      backgroundImage: Image.network(snapshot
                                  .data?[index].photoUrl ??
                              "https://cdn.dribbble.com/users/1162077/screenshots/4318436/media/1e17490dd92ca27c4a6274ab7bff5b11.png?compress=1&resize=400x300")
                          .image,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshot.data?[index].username ?? "",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          snapshot.data?[index].email ?? "",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                  Consumer<GroupChatProvider>(
                    builder: (context, value, child) => Expanded(
                      flex: 1,
                      child: Checkbox(
                        value: value.listAnggotaGroup
                            .contains(snapshot.data?[index].uid),
                        onChanged: (valueCheckBox) {
                          if (valueCheckBox ?? false) {
                            value.addUserToAnggotaGroup(
                                snapshot.data?[index].uid ?? "");
                          } else {
                            value.removeUserFromAnggotaGroup(
                                snapshot.data?[index].uid ?? "");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
