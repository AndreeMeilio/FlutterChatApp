import 'package:belajarfirebase/models/groupchat_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/screens/authentication/login_screen.dart';
import 'package:belajarfirebase/screens/authentication/register_screen.dart';
import 'package:belajarfirebase/screens/chats/chat_screen.dart';
import 'package:belajarfirebase/screens/chats/chatmessage_screen.dart';
import 'package:belajarfirebase/screens/groupchats/groupchat_screen.dart';
import 'package:belajarfirebase/screens/groupchats/groupchatmessage_screen.dart';
import 'package:belajarfirebase/screens/splash_screen.dart';
import 'package:belajarfirebase/screens/users/addstory_screen.dart';
import 'package:belajarfirebase/screens/users/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteConfiguration {
  //function untuk fade transition pada page builder
  FadeTransition _transitionFadeScreen(Animation animation, Widget? child) {
    Tween<double> fadeTween = Tween<double>(begin: 0.0, end: 1.0);

    return FadeTransition(
      opacity: animation.drive(fadeTween),
      child: child,
    );
  }

  //function untuk slide dari samping transition pada page builder
  SlideTransition _transitionSlideScreen(Animation animation, Widget? child) {
    Offset titikAwal = const Offset(1.0, 0.0); //dari kanan layar
    Offset titikAkhir = const Offset(0.0, 0.0); //ke kiri layar

    Tween<Offset> offsetTween =
        Tween<Offset>(begin: titikAwal, end: titikAkhir);

    return SlideTransition(
      position: animation.drive(offsetTween),
      child: child,
    );
  }

  Route<dynamic> onRouteGenerator(RouteSettings settings) {
    String? routeName = settings.name;
    var routeData = settings.arguments;

    switch (routeName) {
      case "/":
        return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, animation, secondaryAnimation) =>
                _transitionFadeScreen(animation, const SplashScreen()));
      case "/login":
        return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, animation, secondaryAnimation) =>
                _transitionFadeScreen(animation, const LoginScreen()));
      case "/register":
        return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, animation, secondaryAnimation) =>
                _transitionFadeScreen(animation, const RegisterScreen()));
      case "/home":
        return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 250),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, animation, secondaryAnimation) =>
                _transitionFadeScreen(animation, ChatScreen()));
      case "/chat":
        return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 250),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, animation, secondaryAnimation) =>
                _transitionSlideScreen(animation,
                    ChatMessageScreen(userToChat: routeData as UserModel)));
      case "/groupchat":
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) =>
              _transitionFadeScreen(animation, GroupChatScreen()),
        );
      case "/groupchatmessage":
        return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 250),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, animation, secondaryAnimation) =>
                _transitionSlideScreen(
                    animation,
                    GroupChatMessageScreen(
                        groupChatModel: routeData as GroupChatModel)));
      case "/profile":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _transitionSlideScreen(
                  animation, ProfileScreen(userModel: routeData as UserModel?)),
        );
      case "/addstory":
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              _transitionSlideScreen(animation, AddStoryScreen()),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
    }
  }
}
