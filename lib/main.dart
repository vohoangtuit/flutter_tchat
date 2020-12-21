import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/controller/bloc/reload_contacts.dart';

import 'package:tchat_app/screens/splash_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';

import 'controller/bloc/account_bloc.dart';
import 'controller/bloc/reload_messsage_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(
  //   MyApp(),
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountBloc()),
        ChangeNotifierProvider(create: (_) => ReloadMessage()),
        ChangeNotifierProvider(create: (_) => ReloadContacts()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale myLocale;
    //print('myLocale ${myLocale.countryCode} ${myLocale.languageCode}');
    return MaterialApp(
      title: 'TChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
   //   home: LoginScreen(title: 'VHT TChat'),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
        // ignore: missing_return
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          myLocale = deviceLocale ; // here you make your app language similar to device language , but you should check whether the localization is supported by your app
        // print(myLocale.countryCode);
        //  print(myLocale.languageCode);
          SharedPre.saveString(SharedPre.sharedPreLanguageCode, myLocale.languageCode);
          SharedPre.saveString(SharedPre.sharedPreCountryCode, myLocale.countryCode);
        }
    );
  }
}