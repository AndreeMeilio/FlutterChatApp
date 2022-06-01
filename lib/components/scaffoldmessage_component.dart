import 'package:flutter/material.dart';

import '../themes/color_theme.dart';

class ScaffoldMessageComponent {
  static showScaffoldComponentMessage(BuildContext context, String pesan){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: ColorsSetting.secondaryColor,
        content: Text(
          pesan,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}