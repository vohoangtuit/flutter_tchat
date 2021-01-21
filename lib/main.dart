import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/controller/bloc/reload_contacts.dart';
import 'package:tchat_app/screens/account/login_screen.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/screens/home_screen.dart';
import 'package:tchat_app/screens/main_screen.dart';

import 'package:tchat_app/screens/splash_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';

import 'controller/bloc/account_bloc.dart';
import 'controller/bloc/reload_messsage_bloc.dart';
import 'database/database.dart';
import 'database/last_message_dao.dart';
import 'database/message_dao.dart';
import 'database/floor_initialize.dart';
import 'database/user_dao.dart';
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
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String screens ='screens';
  bool isLoginApp =false;
  @override
  void initState() {
    checkLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Locale myLocale;
    //print('myLocale ${myLocale.countryCode} ${myLocale.languageCode}');
    return  MaterialApp(
      title: 'TChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        onGenerateRoute: MyRouter.generateRoute,
     // home: SplashScreen(),
      home: isLoginApp != null ?  isLoginApp ? MainScreen(false):LoginScreen():LoginScreen(),
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

 checkLogin()async{
    await SharedPre.getBoolKey(SharedPre.sharedPreIsLogin).then((value){
      if(value!=null){
        setState(() {
          isLoginApp =value;
        });
      }else{
        setState(() {
          isLoginApp =false;
        });
      }
    });
    // await floorDB.getUserDao().getSingleUser().then((value){
    //   if(value!=null){
    //     setState(() {
    //       isLoginApp =true;
    //     });
    //    return true;
    //   }else{
    //     setState(() {
    //       isLoginApp =false;
    //     });
    //
    //   }
    // });
  }
}