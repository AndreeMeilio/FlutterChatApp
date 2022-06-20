import 'package:flutter/material.dart';

class StoryProvider extends ChangeNotifier {
  int indexStory = 0;

  void resetIndexStory() {
    indexStory = 0;

    notifyListeners();
  }

  void incrementIndexStory() {
    indexStory++;

    notifyListeners();
  }

  void decrementIndexStory() {
    indexStory--;

    notifyListeners();
  }
}
