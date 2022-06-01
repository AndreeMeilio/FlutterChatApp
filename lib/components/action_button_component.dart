import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';

class ActionButtonComponent extends StatelessWidget {
  final actionButton;
  final String label;

  ActionButtonComponent({Key? key, required this.actionButton, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).backgroundColor,
        shadowColor: Theme.of(context).primaryColor,
        elevation: 10,
        side: BorderSide(
          color: ColorsSetting.shadowColor,
          width: 1,
        ),
      ),
      onPressed: actionButton,
      child: Text(
        this.label,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}
