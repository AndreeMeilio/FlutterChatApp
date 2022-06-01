import 'package:belajarfirebase/models/groupchat_model.dart';
import 'package:belajarfirebase/models/user_model.dart';
import 'package:belajarfirebase/providers/addstory_provider.dart';
import 'package:belajarfirebase/providers/auth_provider.dart';
import 'package:belajarfirebase/providers/chat_provider.dart';
import 'package:belajarfirebase/providers/groupchat_provider.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/screens/authentication/login_screen.dart';
import 'package:belajarfirebase/screens/authentication/register_screen.dart';
import 'package:belajarfirebase/screens/chats/chat_screen.dart';
import 'package:belajarfirebase/screens/chats/chatmessage_screen.dart';
import 'package:belajarfirebase/screens/groupchats/creategroupchat_screen.dart';
import 'package:belajarfirebase/screens/groupchats/groupchat_screen.dart';
import 'package:belajarfirebase/screens/groupchats/groupchatmessage_screen.dart';
import 'package:belajarfirebase/screens/splash_screen.dart';
import 'package:belajarfirebase/screens/users/addstory_screen.dart';
import 'package:belajarfirebase/screens/users/profile_screen.dart';
import 'package:belajarfirebase/themes/color_theme.dart';
import 'package:belajarfirebase/themes/text_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(
            value: AuthProvider().authUserProvider, initialData: null),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GroupChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddStoryProvider(),
        )
      ],
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          "/": (context) => const SplashScreen(),
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
          "/home": (context) => ChatScreen(),
          "/chat": (context) => ChatMessageScreen(
              userToChat:
                  ModalRoute.of(context)?.settings.arguments as UserModel),
          "/groupchat": (context) => GroupChatScreen(),
          "/createGroupChat": (context) => CreateGroupChatScreen(),
          "/groupchatmessage": (context) => GroupChatMessageScreen(
              groupChatModel:
                  ModalRoute.of(context)?.settings.arguments as GroupChatModel),
          "/profile": (context) => ProfileScreen(
              userModel:
                  ModalRoute.of(context)?.settings.arguments as UserModel?),
          "/addstory": (context) => AddStoryScreen()
        },
        theme: ThemeData(
            textTheme: TextSetting.textTheme,
            primaryColor: ColorsSetting.primaryColor,
            backgroundColor: ColorsSetting.secondaryColor),
      ),
    );
  }
}
