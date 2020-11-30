import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/bloc/account_bloc.dart';
import 'package:tchat_app/bloc/reload_messsage_bloc.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/splash_screen.dart';

import '../utils/const.dart';
import 'login_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(
  //   MyApp(),
  // );
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountBloc()),
        ChangeNotifierProvider(create: (_) => ReloadMessage()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
   //   home: LoginScreen(title: 'VHT TChat'),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}