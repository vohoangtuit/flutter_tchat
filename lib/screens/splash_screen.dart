import 'package:flutter/material.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:tchat_app/widget/text_style.dart';

import '../my_router.dart';
import 'account/login_screen.dart';
import 'main_screen.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widgetLogo(),
            SizedBox(height: 20,),
            Text('Welcome',style: textBlueLarge(),textAlign: TextAlign.center,)
          ],
        ),
      )),
    );
  }
  @override
  void initState() {
    super.initState();
    checkLogin();

  }
  checkLogin()async{
    await SharedPre.getBoolKey(SharedPre.sharedPreIsLogin).then((value){
      Future.delayed(Duration(seconds: 3),()async{
       if(value!=null){
         if(value){
           //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(true)));
           Navigator.of(context).pushReplacementNamed(TAG_MAIN_SCREEN);
         }else{
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
         }
       }else{
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
       }
      }
      );
    });

  }
}
