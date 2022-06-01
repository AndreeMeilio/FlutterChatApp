import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user != null) {
      SchedulerBinding.instance?.addPostFrameCallback((timestamp) {
        Future.delayed(const Duration(seconds: 1),
            () => Navigator.pushReplacementNamed(context, "/home"));
      });
    } else {
      SchedulerBinding.instance?.addPostFrameCallback((timestamp) {
        Future.delayed(const Duration(seconds: 1),
            () => Navigator.pushReplacementNamed(context, "/login"));
      });
    }

    return SafeArea(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            "SPLASH SCREEN",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
