import 'package:belajarfirebase/models/chat_model.dart';
import 'package:belajarfirebase/models/groupchat_model.dart';
import 'package:belajarfirebase/services/chat_service.dart';
import 'package:belajarfirebase/services/groupchat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupChatProvider with ChangeNotifier {
  List<String> listAnggotaGroup = [];

  final CollectionReference _groupChatCollection =
      GroupChatService().groupChatCollection;

  Stream<List<ChatModel>> getDetailMessage(GroupChatModel groupChatModel) =>
      _groupChatCollection
          .doc(groupChatModel.uid)
          .collection("message")
          .orderBy("timeSendMessage")
          .snapshots()
          .map((value) => ChatService().listChatUserFromJson(value));

  Stream<List<GroupChatModel>> listGroupChat(String uid) => _groupChatCollection
      .where("listAnggota", arrayContains: uid)
      .snapshots()
      .map((event) => GroupChatService().listGroupChatFromSnapshot(event));

  void addUserToAnggotaGroup(String uid) {
    listAnggotaGroup.add(uid);
    notifyListeners();
  }

  void removeUserFromAnggotaGroup(String uid) {
    listAnggotaGroup.remove(uid);

    notifyListeners();
  }

  void setListAnggotaGroupToNull() {
    listAnggotaGroup.clear();

    notifyListeners();
  }
}
