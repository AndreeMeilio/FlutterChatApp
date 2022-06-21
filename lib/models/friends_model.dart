class FriendsModel {
  String _tag;
  Map<String, dynamic> _sender;
  String _receiver;
  DateTime _tanggalRequest;
  String? _description;

  FriendsModel(
      {required String tag,
      required Map<String, dynamic> sender,
      required String receiver,
      required DateTime tanggalRequest,
      String? description})
      : _tag = tag,
        _sender = sender,
        _receiver = receiver,
        _tanggalRequest = tanggalRequest,
        _description = description;

  factory FriendsModel.fromJson(dynamic json) {
    return FriendsModel(
        tag: json["tag"],
        sender: json["sender"],
        receiver: json["receiver"],
        tanggalRequest: json["tanggalRequest"],
        description: json["description"]);
  }

  static Map<String, dynamic> toJson(FriendsModel friendsModel) {
    return {
      "tag": friendsModel.tag,
      "sender": friendsModel.sender,
      "receiver": friendsModel.receiver,
      "tanggalRequest": friendsModel.tanggalRequest,
      "description": friendsModel.description
    };
  }

  String get tag => _tag;
  Map<String, dynamic> get sender => _sender;
  String get receiver => _receiver;
  DateTime get tanggalRequest => _tanggalRequest;
  String? get description => _description;
}
