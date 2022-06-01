class ChatModel {
  final String _fromId;
  final String _content;
  final DateTime _timeSendMessage;
  final String? _username;
  final String? _email;
  final String? _photoUrl;

  ChatModel(
      {required String fromId,
      required String content,
      required DateTime timeSendMessage,
      String? username,
      String? email,
      String? photoUrl})
      : _fromId = fromId,
        _content = content,
        _timeSendMessage = timeSendMessage,
        _username = username,
        _email = email,
        _photoUrl = photoUrl;

  // factory ChatModel.fromJson()

  static Map<String, dynamic> toJson(ChatModel chatModel) {
    return <String, dynamic>{
      "fromId": chatModel.fromId,
      "username": chatModel.username,
      "email": chatModel.email,
      "photoUrl": chatModel.photoUrl,
      "content": chatModel.content,
      "timeSendMessage": chatModel.timeSendMessage,
    };
  }

  String get fromId => _fromId;
  String get content => _content;
  DateTime get timeSendMessage => _timeSendMessage;
  String? get username => _username;
  String? get email => _email;
  String? get photoUrl => _photoUrl;
}
