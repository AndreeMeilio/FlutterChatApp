import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:flutter/material.dart';

class FloatingActionComponent extends StatelessWidget {
  FloatingActionComponent({Key? key, required this.action}) : super(key: key);

  VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: action,
      backgroundColor: ColorsSetting.secondaryColor,
      foregroundColor: ColorsSetting.primaryColor,
      child: const Icon(Icons.add),
    );
  }
}
