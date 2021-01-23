
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/controller/bloc/reload_contacts.dart';

import 'package:tchat_app/screens/check_login_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';

import 'controller/bloc/account_bloc.dart';
import 'controller/bloc/reload_messsage_bloc.dart';
import 'database/floor_initialize.dart';
import 'controller/my_router.dart';

FloorInitialize floorDB =FloorInitialize();
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await initializeFloorDB();
  await Firebase.initializeApp();

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
initializeFloorDB()async{
   floorDB.init();
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale myLocale;
    //print('myLocale ${myLocale.countryCode} ${myLocale.languageCode}');
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TChat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: MyRouter.generateRoute,
        home: CheckLoginScreen(),
        //home: isLoginApp != null ?  isLoginApp ? MainScreen(false):LoginScreen():LoginScreen(),
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

