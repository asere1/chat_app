import 'package:flutter/material.dart';
import 'package:new_chat_app/utilits/navigations.dart';

import '../../utilits/Images.dart';
import '../widgets/button_widget.dart';

class WellcomeScreen extends StatefulWidget {
  const WellcomeScreen({Key? key}) : super(key: key);

  @override
  State<WellcomeScreen> createState() => _WellcomeScreenState();
}

class _WellcomeScreenState extends State<WellcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              child: Image.asset(
                Images.logoImg,
              ),
            ),
            Button(
                title: 'Log In',
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRouts.logeScreen);
                },
                color: Colors.greenAccent),
            const SizedBox(
              height: 10,
            ),
            Button(
                title: 'Sing Up',
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRouts.singScreen);
                },
                color: Colors.black)
          ],
        ),
      )),
    );
  }
}
