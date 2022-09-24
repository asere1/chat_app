import 'package:flutter/material.dart';
import 'package:new_chat_app/view/pages/chat_screen.dart';
import 'package:new_chat_app/view/pages/loge_in_screen.dart';
import 'package:new_chat_app/view/pages/sing_up_screen.dart';
import 'package:new_chat_app/view/pages/welcome_screen.dart';

class AppRouts {
  static const String logeScreen = '/loge';
  static const String wellcomeScreen = '/wellcome';
  static const String singScreen = '/sing';
  static const String chatScreen = '/chat';
}

Route<dynamic> onGenerate(RouteSettings settings) {
  switch (settings.name) {
    case AppRouts.logeScreen:
      return MaterialPageRoute(
          builder: (_) => const LogeInScreen(), settings: settings);

    case AppRouts.singScreen:
      return MaterialPageRoute(
          builder: (_) => const SingUpScreen(), settings: settings);

    case AppRouts.chatScreen:
      return MaterialPageRoute(
          builder: (_) => const ChatScreen(), settings: settings);

    case AppRouts.wellcomeScreen:
    default:
      return MaterialPageRoute(
          builder: (_) => const WellcomeScreen(), settings: settings);
  }
}
