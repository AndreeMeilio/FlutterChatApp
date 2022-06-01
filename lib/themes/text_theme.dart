import 'package:belajarfirebase/themes//color_theme.dart';
import 'package:flutter/material.dart';

class TextSetting {
  static const String fontFamily = "PlayfairDisplay";

  static final TextTheme textTheme = TextTheme(
    headline1: TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: ColorsSetting.textColor),
    headline2: TextStyle(
        fontFamily: fontFamily,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: ColorsSetting.textColor),
    headline3: TextStyle(
        fontFamily: fontFamily, fontSize: 20, color: ColorsSetting.textColor),
    bodyText1: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorsSetting.textColor),
    bodyText2: TextStyle(
        fontFamily: fontFamily, fontSize: 18, color: ColorsSetting.textColor),
    button: TextStyle(
        fontFamily: fontFamily, fontSize: 20, color: ColorsSetting.textColor),
  );
}
