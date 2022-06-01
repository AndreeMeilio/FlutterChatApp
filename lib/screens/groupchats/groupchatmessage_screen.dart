import 'package:belajarfirebase/components/appbar_component.dart';
import 'package:belajarfirebase/components/bubblechatuser_component.dart';
import 'package:belajarfirebase/components/text_field_component.dart';
import 'package:belajarfirebase/models/chat_model.dart';
import 'package:belajarfirebase/models/groupchat_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/chat_provider.dart';
import 'package:belajarfirebase/providers/groupchat_provider.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/services/auth_service.dart';
import 'package:belajarfirebase/services/groupchat_service.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChatMessageScreen extends StatelessWidget {
  GroupChatMessageScreen({Key? key, required this.groupChatModel})
      : super(key: key);

  final GroupChatModel groupChatModel;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBarComponent(
        auth: _authService,
        label: groupChatModel.groupname,
        photoUrl: groupChatModel.photoUrl,
        showAction: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: Image.network(
                      "https://cdn.dribbble.com/users/1162077/screenshots/4318436/media/1e17490dd92ca27c4a6274ab7bff5b11.png?compress=1&resize=400x300")
                  .image,
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15),
              child: ListGroupChatUser(
                groupChatModel: groupChatModel,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                color: ColorsSetting.secondaryColor,
                child: FormSendMessage(groupChatModel: groupChatModel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListGroupChatUser extends StatelessWidget {
  const ListGroupChatUser({Key? key, required this.groupChatModel})
      : super(key: key);

  final GroupChatModel groupChatModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatModel>>(
      stream: GroupChatProvider().getDetailMessage(groupChatModel),
      builder: (context, snapshot) => (snapshot.data?.isNotEmpty ?? false)
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final int lastIndex = ((snapshot.data?.length ?? 0) - 1);
                double marginBottomLastIndex = 100;
                return Container(
                  margin: EdgeInsets.only(
                    bottom: (lastIndex == index) ? marginBottomLastIndex : 10,
                  ),
                  child: BubbleChatUser(
                    snapshot: snapshot,
                    index: index,
                  ),
                );
              },
            )
          : Container(),
    );
  }
}

class FormSendMessage extends StatefulWidget {
  const FormSendMessage({Key? key, required this.groupChatModel})
      : super(key: key);

  final GroupChatModel groupChatModel;

  @override
  State<FormSendMessage> createState() => _FormSendMessageState();
}

class _FormSendMessageState extends State<FormSendMessage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).currentUserModel;
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Consumer<ChatProvider>(
            builder: ((context, value, child) {
              return TextFieldComponent(
                textEditingController: _messageController,
                label: "Send Message",
                textError: value.isTextFieldNull,
              );
            }),
          ),
        ),
        Expanded(
          flex: 1,
          child: Consumer<ChatProvider>(
            builder: (context, value, child) {
              return IconButton(
                onPressed: () async {
                  bool isTextMessageNotNull =
                      value.checkTextField(_messageController.text);
                  if (isTextMessageNotNull) {
                    String content = _messageController.text;
                    _messageController.clear();
                    await GroupChatService().sendMessage(
                      user,
                      widget.groupChatModel,
                      content,
                    );
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
