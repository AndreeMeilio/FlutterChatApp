import 'dart:async';

import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/components/bottommenu_component.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/StoryProvider.dart';
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
        backgroundColor: ColorsSetting.shadowColor,
        color: ColorsSetting.secondaryColor,
        onRefresh: Provider.of<UserProvider>(context).listUserStories,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: ColorsSetting.secondaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.elliptical(250, 40),
                      bottomRight: Radius.elliptical(250, 40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsSetting.shadowColor,
                        blurRadius: 15,
                        spreadRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                child: const StatusUser(),
              ),
            ),
            const Expanded(
              flex: 2,
              child: DividerStatusAndUser(),
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

//status user avatar
class StatusUser extends StatefulWidget {
  const StatusUser({Key? key}) : super(key: key);

  @override
  State<StatusUser> createState() => _StatusUserState();
}

class _StatusUserState extends State<StatusUser> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      Provider.of<UserProvider>(context).resetDataStoriesUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.read<UserProvider>().listUserStories().then((value) => null);
    return Consumer<UserProvider>(
      builder: (context, value, child) => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: value.listStoriesUser.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                barrierColor: Colors.black87,
                context: context,
                builder: (context) {
                  return StoryContent(
                    user: value.listStoriesUser[index],
                  );
                },
              );
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorsSetting.shadowColor,
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsSetting.shadowColor,
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ]),
                margin: EdgeInsets.only(right: 15, left: (index == 0) ? 15 : 0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: Image.network(value
                              .listStoriesUser[index]?.photoUrl ??
                          "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
                      .image,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//build list user
class ListUserChat extends StatelessWidget {
  const ListUserChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: UserProvider().listUser,
      builder: (context, snapshot) {
        return ListView.builder(
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

//User Chat Component / list user
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

//Divider status dan list user
class DividerStatusAndUser extends StatelessWidget {
  const DividerStatusAndUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          const Expanded(
            flex: 2,
            child: Divider(
              thickness: 5,
              color: Colors.white,
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorsSetting.secondaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Start Conversation With Your Friend",
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Divider(
              thickness: 5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class StoryContent extends StatefulWidget {
  const StoryContent({Key? key, required this.user}) : super(key: key);

  final UserModel? user;

  @override
  State<StoryContent> createState() => _StoryContentState();
}

class _StoryContentState extends State<StoryContent>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      Provider.of<StoryProvider>(context).resetIndexStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, value, child) {
        Timer(const Duration(seconds: 5), () {
          print("di future delayed story content: ${value.indexStory}");
          if (value.indexStory == (widget.user!.storyUser!.length - 1)) {
            value.resetIndexStory();
            Navigator.pop(context);
          } else {
            value.incrementIndexStory();
          }
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LinearProgressIndicator(
              value: AnimationController(
                      vsync: this, duration: const Duration(seconds: 5))
                  .value,
              color: Theme.of(context).primaryColor,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_rounded)),
                  CircleAvatar(
                    backgroundImage:
                        Image.network(widget.user!.photoUrl!).image,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.user!.username!,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.network(
                            widget.user!.storyUser![value.indexStory].urlFile)
                        .image,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Text(
                widget.user!.storyUser![value.indexStory].caption,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            )
          ],
        );
      },
    );
  }
}
