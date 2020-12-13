import 'package:flutter/material.dart';
import 'package:tchat_app/base/account_statefulwidget.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:tchat_app/widget/button.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends AccountBaseState<SettingScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithTitle(context,'Settings'),
      body: Container(
        child: Column(
          children: [
            NormalButton(title: 'LogOut',onPressed: (){
              checkAccountForLogout();
            },),
          ],
        ),
      ),
    );
  }
  checkAccountForLogout()async{
    await SharedPre.getIntKey(SharedPre.sharedPreAccountType).then((value) {
      if(value!=null){
        if(value==USER_ACCOUNT_FACEBOOK){
          logOutFacebook();
        }
        else if(value==USER_ACCOUNT_GMAIL){
          logoutGoogle();
        }else{
          print('please check again account type');
        }
      }
    });
  }
  Future<Null> logoutGoogle() async {
    this.setState(() {
      isLoading = true;
    });

    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await SharedPre.clearData();

    this.setState(() {
      isLoading = false;
      userModel =null;
    });

    openMyAppAndRemoveAll();
  }
  Future<void> logOutFacebook() async {
    setState(() {
      isLoading = true;
    });
    await facebookLogin.logOut();
    setState(() {
      isLoading = false;
    });
    await SharedPre.clearData();
    openMyAppAndRemoveAll();
  }

  @override
  void uploadAvatarCover(UserModel user, bool success) {

  }
}
