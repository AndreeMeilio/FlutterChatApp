import 'package:belajarfirebase/models/chat_model.dart';
import 'package:belajarfirebase/models/groupchat_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatService {
  final CollectionReference _groupchatCollection =
      FirebaseFirestore.instance.collection("groupchat");

  CollectionReference get groupChatCollection => _groupchatCollection;

  Future<DocumentReference?> createNewGroup(
      String groupname, String photoUrl, List<String> listAnggota) async {
    try {
      DocumentReference dataCreatedGroup = await _groupchatCollection.add(
        GroupChatModel.toJson(
          GroupChatModel(
              groupname: groupname,
              photoUrl: photoUrl,
              listAnggota: listAnggota),
        ),
      );

      return dataCreatedGroup;
    } catch (e) {
      print("error di create new group: $e");
      return null;
    }
  }

  Future<DocumentReference> sendMessage(UserModel userModel,
      GroupChatModel groupChatModel, String content) async {
    final DateTime timeSendMessage = DateTime.now();

    final DocumentReference sendMessageToGroup = await _groupchatCollection
        .doc(groupChatModel.uid)
        .collection("message")
        .add(ChatModel.toJson(
          ChatModel(
            fromId: userModel.uid ?? '',
            username: userModel.username,
            email: userModel.email,
            photoUrl: userModel.photoUrl,
            content: content,
            timeSendMessage: timeSendMessage,
          ),
        ));

    return sendMessageToGroup;
  }

  List<GroupChatModel> listGroupChatFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (value) => GroupChatModel(
            uid: value.id,
            groupname: value["groupname"],
            photoUrl: value["photoUrl"],
            listAnggota: value["listAnggota"],
          ),
        )
        .toList();
  }
}
