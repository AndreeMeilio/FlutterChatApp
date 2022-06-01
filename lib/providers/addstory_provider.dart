import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddStoryProvider extends ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  File? fileStory;

  Future<void> pickFileStory() async {
    try {
      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
        dialogTitle: "Pick File Image For Story",
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      );

      if (filePickerResult?.paths.isNotEmpty ?? false) {
        fileStory = File(filePickerResult?.files.single.path ?? '');
      } else {
        fileStory = null;
      }
    } catch (e) {
      fileStory = null;
      print("error di pickFile Story: $e");
    }
    notifyListeners();
  }
}
