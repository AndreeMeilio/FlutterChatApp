import 'package:belajarfirebase/models/chat_model.dart';
import 'package:belajarfirebase/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  bool isTextFieldNull = false;
  final ChatService _chatService = ChatService();

  bool checkTextField(String text) {
    if (text.isNotEmpty) {
      isTextFieldNull = false;

      notifyListeners();
      return true;
    } else {
      isTextFieldNull = true;

      notifyListeners();
      return false;
    }
  }

  Stream<List<ChatModel>> detailChatUser(String fromId, String toId) {
    final String chatUserDoc =
        fromId.hashCode <= toId.hashCode ? "$fromId-$toId" : "$toId-$fromId";

    return _chatService.chatCollection
        .doc(chatUserDoc)
        .collection("message")
        .orderBy("timeSendMessage")
        .snapshots()
        .map((value) => _chatService.listChatUserFromJson(value));
  }
}
