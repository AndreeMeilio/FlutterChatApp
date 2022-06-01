import 'package:flutter/material.dart';

class LoadingComponent {
  static showLoadingComponent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(strokeWidth: 8),
      ),
    );
  }
}
