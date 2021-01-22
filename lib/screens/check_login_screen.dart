import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/controller/my_router.dart';
import 'package:tchat_app/screens/account/login_screen.dart';
import 'package:tchat_app/screens/splash_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';

class CheckLoginScreen extends StatefulWidget {
  @override
  _CheckLoginScreenState createState() => _CheckLoginScreenState();
}
class _CheckLoginScreenState extends State<CheckLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
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
