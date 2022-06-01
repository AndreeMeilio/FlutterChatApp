class StoryUser {
  String _caption;
  String _urlFile;
  String _namaFile;
  DateTime _postTime;
  List<String>? _views;

  StoryUser(
      {required String caption,
      required String urlFile,
      required String namaFile,
      required DateTime postTime,
      List<String>? views})
      : _caption = caption,
        _urlFile = urlFile,
        _namaFile = namaFile,
        _postTime = postTime,
        _views = views;

  static Map<String, dynamic> toJson(StoryUser storyUser) {
    return {
      "caption": storyUser.caption,
      "urlFile": storyUser.urlFile,
      "namaFile": storyUser.namaFile,
      "postTime": storyUser.postTime,
      "views": storyUser.views
    };
  }

  String get caption => _caption;
  String get urlFile => _urlFile;
  String get namaFile => _namaFile;
  DateTime get postTime => _postTime;
  List<String>? get views => _views;
}
