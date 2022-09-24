import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app/view/pages/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utilits/navigations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message Me',
      theme: ThemeData(),
      onGenerateRoute: onGenerate,
      initialRoute: _auth.currentUser != null
          ? AppRouts.chatScreen
          : AppRouts.wellcomeScreen,
      // home: ChatScreen(),
    );
  }
}
