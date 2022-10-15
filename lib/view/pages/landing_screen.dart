import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app/view/pages/profile_screen.dart';
import 'package:new_chat_app/view/pages/welcome_screen.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);

  final _firebaseAuth = FirebaseAuth.instance;
  //git

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return const WellcomeScreen();
            }
            return const ProfileScreen();
          }
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          ));
        });
  }
}
