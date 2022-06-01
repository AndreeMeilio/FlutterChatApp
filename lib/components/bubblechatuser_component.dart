import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../themes/color_theme.dart';

class BubbleChatUser extends StatelessWidget {
  const BubbleChatUser({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  final AsyncSnapshot<List<ChatModel>> snapshot;
  final int index;

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).currentUserModel;

    double radiusBottomRight = 0;
    double radiusBottomLeft = 0;

    if (user.uid == snapshot.data?[index].fromId) {
      radiusBottomLeft = 25;
    } else {
      radiusBottomRight = 25;
    }

    List<Widget> listBubbleChatContent = [
      Expanded(
        flex: 1,
        child: CircleAvatar(
          radius: 20,
          backgroundImage: Image.network(snapshot.data?[index].photoUrl ??
                  "https://sman93jkt.sch.id/wp-content/uploads/2018/01/765-default-avatar.png")
              .image,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Flexible(
        flex: 9,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: (user.uid == snapshot.data?[index].fromId)
                ? Colors.lightBlue[100]
                : ColorsSetting.secondaryColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
                bottomRight: Radius.circular(radiusBottomRight),
                bottomLeft: Radius.circular(radiusBottomLeft)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data?[index].username ?? "",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(snapshot.data?[index].content ?? ""),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(
          "${snapshot.data?[index].timeSendMessage.hour}:${snapshot.data?[index].timeSendMessage.minute}",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: ColorsSetting.secondaryColor),
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: (user.uid == snapshot.data?[index].fromId)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: (user.uid == snapshot.data?[index].fromId)
          ? listBubbleChatContent.reversed.toList()
          : listBubbleChatContent.toList(),
    );
  }
}
