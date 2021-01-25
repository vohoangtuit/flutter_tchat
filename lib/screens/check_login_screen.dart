import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/controller/my_router.dart';
import 'package:tchat_app/screens/account/login_screen.dart';
import 'package:tchat_app/screens/splash_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/basewidget.dart';

class CheckLoginScreen extends StatefulWidget {
  @override
  _CheckLoginScreenState createState() => _CheckLoginScreenState();
}
class _CheckLoginScreenState extends State<CheckLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // color: Colors.blue,
      appBar: appBarWithTitle(context,''),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              color: Colors.white,
              child:  Container(height: 1.0, color: Colors.grey[200]),
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
  }
  checkLogin()async{
    await SharedPre.getBoolKey(SharedPre.sharedPreIsLogin).then((value){
      if(value!=null){
        Navigator.pushReplacementNamed(context, TAG_MAIN_SCREEN);
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      }
    });
  }
}
