import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/text_field_component.dart';

class AddFriendScreen extends StatelessWidget {
  AddFriendScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarComponent(auth: _auth, label: "Add Friends", showAction: false),
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
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).currentUserModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Counter New Friend",
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Search By Email",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFieldComponent(
                textEditingController: _emailController,
                label: "Search your friend email",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            IconButton(
              iconSize: 35,
              onPressed: () async {
                Provider.of<UserProvider>(context, listen: false)
                    .listUserForAddFriend(email: _emailController.text);
              },
              icon: Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          "This's maybe what you looking for",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          height: 15,
        ),
        const Expanded(child: ListFindFriend())
      ],
    );
  }
}

class ListFindFriend extends StatelessWidget {
  const ListFindFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, value, Widget? child) {
        print("di listfindfriend: ${value.listForAddFriends}");
        return value.listForAddFriends != null
            ? ListView.builder(
                itemCount: value.listForAddFriends?.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundImage: Image.network(value
                                      .listForAddFriends?[index].photoUrl ??
                                  "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
                              .image,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              value.listForAddFriends?[index].username ?? "",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              value.listForAddFriends?[index].email ?? "",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send_sharp,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Text(
                "We can find your friend",
                style: Theme.of(context).textTheme.bodyText2,
              );
      },
    );
  }
}
