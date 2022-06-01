import 'package:belajarfirebase/models/chat_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final CollectionReference _chatCollection =
      FirebaseFirestore.instance.collection("chats");

  CollectionReference get chatCollection => _chatCollection;

  Future<DocumentReference> sendMessage(
      UserModel fromUser, String toId, String content) async {
    final String chatUserDoc = fromUser.uid.hashCode <= toId.hashCode
        ? "${fromUser.uid}-$toId"
        : "$toId-${fromUser.uid}";

    final DateTime timeSendMessage = DateTime.now();
    // final String timeSendMessage = "${dateNow.hour}:${dateNow.hour}";

    final DocumentReference sendMessage = await _chatCollection
        .doc(chatUserDoc)
        .collection("message")
        .add(ChatModel.toJson(
          ChatModel(
            fromId: fromUser.uid ?? '',
            username: fromUser.username,
            email: fromUser.email,
            photoUrl: fromUser.photoUrl,
            content: content,
            timeSendMessage: timeSendMessage,
          ),
        ));

    return sendMessage;
  }

  List<ChatModel> listChatUserFromJson(QuerySnapshot snapshot) {
    print("di list chat user from json: ${snapshot.docs[0]["username"]}");
    return snapshot.docs
        .map(
          (value) => ChatModel(
            fromId: value["fromId"],
            username: value["username"],
            email: value["email"],
            photoUrl: value["photoUrl"],
            content: value["content"],
            timeSendMessage: value["timeSendMessage"].toDate(),
          ),
        )
        .toList();
  }
}
