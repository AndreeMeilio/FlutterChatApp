import 'package:belajarfirebase/providers/StoryProvider.dart';
import 'package:belajarfirebase/providers/addstory_provider.dart';
import 'package:belajarfirebase/providers/auth_provider.dart';
import 'package:belajarfirebase/providers/chat_provider.dart';
import 'package:belajarfirebase/providers/groupchat_provider.dart';
import 'package:belajarfirebase/providers/user_provider.dart';
import 'package:belajarfirebase/route_configuration.dart';
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
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: RouteConfiguration().onRouteGenerator,
        theme: ThemeData(
            textTheme: TextSetting.textTheme,
            primaryColor: ColorsSetting.primaryColor,
            backgroundColor: ColorsSetting.secondaryColor),
      ),
    );
  }
}
