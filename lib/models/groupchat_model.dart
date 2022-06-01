class GroupChatModel {
  String? _uid;
  String _groupname;
  String? _photoUrl;
  List<dynamic> _listAnggota;

  GroupChatModel(
      {String? uid,
      required String groupname,
      String? photoUrl,
      required List<dynamic> listAnggota})
      : _uid = uid,
        _groupname = groupname,
        _photoUrl = photoUrl,
        _listAnggota = listAnggota;

  static Map<String, dynamic> toJson(GroupChatModel groupChatModel) {
    return <String, dynamic>{
      "groupname": groupChatModel.groupname,
      "photoUrl": groupChatModel.photoUrl,
      "listAnggota": groupChatModel.listAnggota
    };
  }

  String? get uid => _uid;
  String get groupname => _groupname;
  String? get photoUrl => _photoUrl;
  List<dynamic> get listAnggota => _listAnggota;
}
