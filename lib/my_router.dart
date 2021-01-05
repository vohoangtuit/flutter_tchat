
import 'package:flutter/material.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/account/update_account_screen.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/screens/friends/user_profile_screen.dart';
import 'package:tchat_app/screens/main_screen.dart';
import 'package:tchat_app/screens/setting_screen.dart';
import 'package:tchat_app/screens/splash_screen.dart';

const String TAG_SPLASH_SCREEN = '/';
const String TAG_MAIN_SCREEN = '/MainScreen';
const String TAG_CHAT_SCREEN = '/chatScreen';
const String TAG_USER_PROFILE_SCREEN = '/user_profile_screen';
const String TAG_SETTING_SCREEN = '/setting_screen';
const String TAG_UPDATE_ACCOUNT = '/update_account_screen';

class  MyRouter {
  static  Route<dynamic> generateRoute(RouteSettings settings) {
    print('MyRouter ${settings.name}');
    switch (settings.name) {
      case TAG_SPLASH_SCREEN:
        return MaterialPageRoute(settings: settings,builder: (_) => SplashScreen());
        break;
      case TAG_MAIN_SCREEN:
        var synData = settings.arguments as bool;
        return MaterialPageRoute(settings: settings,builder: (_) => MainScreen(synData));
        break;
      case TAG_CHAT_SCREEN:
        var data = settings.arguments as String;
        return MaterialPageRoute(settings: settings,builder: (_) => ChatScreen(data));
        break;
      case TAG_USER_PROFILE_SCREEN:
        var myProfile = settings.arguments as UserModel;
        var user = settings.arguments as UserModel;
        return MaterialPageRoute(settings: settings,builder: (_) => UserProfileScreen(myProfile:myProfile,user: user));
        break;
      case TAG_SETTING_SCREEN:
      return MaterialPageRoute(settings: settings,builder: (_) => SettingScreen());
      break;
      case TAG_UPDATE_ACCOUNT:
        var user = settings.arguments as UserModel;
        return MaterialPageRoute(settings: settings,builder: (_) => UpdateAccountScreen(user));
        break;
    }
  }
}

