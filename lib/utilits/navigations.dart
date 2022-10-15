import 'package:flutter/material.dart';
import 'package:new_chat_app/view/pages/chat_screen.dart';
import 'package:new_chat_app/view/pages/landing_screen.dart';
import 'package:new_chat_app/view/pages/log_in_screen.dart';
import 'package:new_chat_app/view/pages/sing_up_screen.dart';
import 'package:new_chat_app/view/pages/welcome_screen.dart';

import '../view/pages/profile_screen.dart';

class AppRouts {
  static const String logeScreen = '/loge';
  static const String wellcomeScreen = '/wellcome';
  static const String singScreen = '/sing';
  static const String chatScreen = '/chat';
  static const String profileScreen = '/profile';
  static const String landingScreen = '/landing';
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

    case AppRouts.landingScreen:
      return MaterialPageRoute(
          builder: (_) => LandingScreen(), settings: settings);

    case AppRouts.profileScreen:
      return MaterialPageRoute(
          builder: (_) => const ProfileScreen(), settings: settings);

    case AppRouts.wellcomeScreen:
    default:
      return MaterialPageRoute(
          builder: (_) => const WellcomeScreen(), settings: settings);
  }
}
