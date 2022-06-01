import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/components/bottommenu_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBarComponent(auth: _auth, isChatScreen: true),
      body: RefreshIndicator(
        onRefresh: Provider.of<UserProvider>(context).listUserStories,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: ColorsSetting.secondaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: ColorsSetting.shadowColor,
                        blurRadius: 15,
                        spreadRadius: 3)
                  ],
                ),
                child: const StatusUser(),
              ),
            ),
            Expanded(
              flex: 13,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const ListUserChat(),
                  ),
                  BottomMenu(
                    menuActive: "chat",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusUser extends StatelessWidget {
  const StatusUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: value.listStoriesUser.length,
        itemBuilder: (context, index) {
          print(
              "di list: ${value.listStoriesUser}/ ${value.listStoriesUser.length}");
          return Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorsSetting.shadowColor,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              margin: EdgeInsets.only(right: 15, left: (index == 0) ? 15 : 0),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: Image.network(value
                            .listStoriesUser[index]?.photoUrl ??
                        "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
                    .image,
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListUserChat extends StatelessWidget {
  const ListUserChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: UserProvider().listUser,
      builder: (context, snapshot) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return UserChatComponent(
                userModel: snapshot.data?[index],
                lastIndex: (snapshot.data?.length ?? 0) - 1 == index);
          },
        );
      },
    );
  }
}

class UserChatComponent extends StatelessWidget {
  const UserChatComponent(
      {Key? key, required this.userModel, this.lastIndex = false})
      : super(key: key);

  final bool lastIndex;
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/chat", arguments: userModel);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: lastIndex ? 100 : 10),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: ColorsSetting.shadowColor, width: 3),
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    backgroundImage: Image.network(userModel?.photoUrl ??
                            "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
                        .image,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        userModel?.username ?? "",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        userModel?.email ?? "",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
