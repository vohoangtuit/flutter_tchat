import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/screens/splash_screen.dart';

import '../utils/const.dart';
import 'login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
   //   home: LoginScreen(title: 'VHT TChat'),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}