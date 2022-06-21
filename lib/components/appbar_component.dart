import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/friends_provider.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/services/friends_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarComponent extends StatelessWidget with PreferredSizeWidget {
  AppBarComponent(
      {Key? key,
      required this.auth,
      this.label,
      this.photoUrl,
      this.showAction = true,
      this.isGroupChatScreen = false,
      this.isChatScreen = false})
      : super(key: key);

  final AuthService auth;
  final String? label;
  final String? photoUrl;
  final bool showAction;
  final bool isGroupChatScreen;
  final bool isChatScreen;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: _globalKey,
      backgroundColor: ColorsSetting.secondaryColor,
      foregroundColor: Colors.black,
      titleSpacing: 0,
      elevation: 0,
      title: (photoUrl != null)
          ? Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                      radius: 20,
                      backgroundImage: Image.network(photoUrl ?? "").image),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      label ?? "",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            )
          : ((label != null)
              ? Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    label ?? "",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Talky Time",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                )),
      actions: showAction
          ? <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        enableDrag: true,
                        context: context,
                        builder: (context) => Container(
                          height: 500,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const <Widget>[
                              Center(
                                child: Divider(
                                  indent: 100,
                                  endIndent: 100,
                                  color: Colors.grey,
                                  thickness: 5,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Expanded(child: ListNotification())
                            ],
                          ),
                        ),
                      );
                    },
                    icon: StreamBuilder<List<UserModel>>(
                      stream: FriendsProvider().getNotificationRequestFriend,
                      builder: (context, snapshot) {
                        if (snapshot.data?.isNotEmpty ?? false) {
                          return const Icon(
                            Icons.notifications_active_sharp,
                            color: Colors.red,
                          );
                        } else {
                          return Icon(
                            Icons.notifications,
                            color: Theme.of(context).primaryColor,
                          );
                        }
                      },
                    )),
              ),
              isGroupChatScreen
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/createGroupChat");
                        },
                        icon: Icon(
                          Icons.group_add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 1,
                    ),
              isChatScreen
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/addfriends");
                        },
                        icon: Icon(
                          Icons.person_add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 1,
                    ),
              ProfileMenu(auth: auth),
            ]
          : null,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({Key? key, required this.auth}) : super(key: key);

  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).currentUserModel;
    return PopupMenuButton(
      elevation: 15,
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            onTap: () async {
              Navigator.pushNamed(context, "/profile", arguments: user);
            },
            leading: const Icon(Icons.person),
            title: Text(
              "Profile",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        PopupMenuItem(
          child: Consumer<UserProvider>(
            builder: (context, value, child) => ListTile(
              onTap: () async {
                await auth.signOutUser();
                value.resetCurrentUserModel();
                value.resetDataStoriesUser();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              },
              leading: const Icon(Icons.logout),
              title: Text(
                "Logout",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        )
      ],
      offset: const Offset(-50, 30),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        side: BorderSide(
          color: ColorsSetting.shadowColor,
          width: 3,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 15,
            backgroundImage: Image.network(user.photoUrl?.isNotEmpty ?? false
                    ? user.photoUrl!
                    : "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
                .image,
          ),
        ),
      ),
    );
  }
}

class ListNotification extends StatelessWidget {
  const ListNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: FriendsProvider().getNotificationRequestFriend,
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () async {
                            await FriendsService().acceptOrRejectFriendRequest(
                                snapshot.data![index],
                                AuthService().getCurrentUserLoginId());
                          },
                          icon: const Icon(
                            Icons.thumb_down,
                            color: Colors.redAccent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            backgroundImage: Image.network(snapshot
                                        .data?[index].photoUrl ??
                                    "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
                                .image,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data?[index].username ?? "",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                snapshot.data?[index].email ?? "",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await FriendsService().acceptOrRejectFriendRequest(
                                snapshot.data![index],
                                AuthService().getCurrentUserLoginId(),
                                isAccepted: true);
                          },
                          icon: Icon(
                            Icons.thumb_up,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      "Send you friend request",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              "There is no new notification",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
      },
    );
  }
}
