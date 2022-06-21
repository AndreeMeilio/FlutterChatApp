import 'package:belajarfirebase/models/friends_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/services/users_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsService {
  final CollectionReference _friendsCollection =
      FirebaseFirestore.instance.collection("friends");
  final CollectionReference _userCollection = UsersService().userCollection;

  CollectionReference get friendsCollection => _friendsCollection;

  Future<bool> sendFriendRequest(UserModel userSender, String idReceiver,
      [String? description]) async {
    final String friendsDocId = userSender.uid.hashCode <= idReceiver.hashCode
        ? "${userSender.uid}-$idReceiver"
        : "$idReceiver-${userSender.uid}";

    final DateTime dateSending = DateTime.now();

    try {
      await _friendsCollection.doc(friendsDocId).set(FriendsModel.toJson(
          FriendsModel(
              tag: friendsDocId,
              sender: UserModel.toJson(userSender),
              receiver: idReceiver,
              tanggalRequest: dateSending,
              description: description)));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> acceptOrRejectFriendRequest(
      UserModel userSender, String idReceiver,
      {bool isAccepted = false}) async {
    final String friendsDocId = userSender.uid.hashCode <= idReceiver.hashCode
        ? "${userSender.uid}-$idReceiver"
        : "$idReceiver-${userSender.uid}";

    try {
      await _friendsCollection.doc(friendsDocId).delete();

      if (isAccepted) {
        //add id sender into field friends for the receiver
        DocumentSnapshot userReceiverDoc =
            await _userCollection.doc(idReceiver).get();
        dynamic userData = userReceiverDoc.data();
        List<dynamic> listFriends = userData["friends"];
        listFriends.add(userSender.uid ?? "");
        await _userCollection.doc(idReceiver).update({"friends": listFriends});

        //add id receiver into field friends for the sender
        DocumentSnapshot userSenderDoc =
            await _userCollection.doc(userSender.uid).get();
        dynamic userSenderData = userSenderDoc.data();
        List<dynamic> listFriendsSender = userSenderData["friends"];
        listFriendsSender.add(idReceiver);
        await _userCollection
            .doc(userSender.uid)
            .update({"friends": listFriends});
      }
    } catch (e) {}
  }
}
