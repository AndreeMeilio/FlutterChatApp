import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/components/bottommenu_component.dart';
import 'package:belajarfirebase/models/groupchat_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/groupchat_provider.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChatScreen extends StatelessWidget {
  GroupChatScreen({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        auth: _auth,
        label: "Group Chat",
        isGroupChatScreen: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: const ListGroupChat(),
          ),
          BottomMenu(
            menuActive: "groupchat",
          )
        ],
      ),
    );
  }
}

class ListGroupChat extends StatelessWidget {
  const ListGroupChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).currentUserModel;
    return StreamBuilder<List<GroupChatModel>>(
      stream: GroupChatProvider().listGroupChat(
        user.uid ?? "",
      ),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) =>
                ItemListGroupChat(groupChatModel: snapshot.data?[index]),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ItemListGroupChat extends StatelessWidget {
  const ItemListGroupChat({Key? key, required this.groupChatModel})
      : super(key: key);

  final GroupChatModel? groupChatModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/groupchatmessage",
            arguments: groupChatModel);
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  backgroundImage: Image.network(groupChatModel?.photoUrl ??
                          "https://cdn.dribbble.com/users/1162077/screenshots/4318436/media/1e17490dd92ca27c4a6274ab7bff5b11.png?compress=1&resize=400x300")
                      .image,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      groupChatModel?.groupname ?? "",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "Jumlah Anggota : ${groupChatModel?.listAnggota.length}",
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
    );
  }
}
