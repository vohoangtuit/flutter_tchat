import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';

import 'bases_statefulwidget.dart';

abstract class AccountBaseState <T extends StatefulWidget> extends BaseStatefulWidget{

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  FirebaseDataFunc firebaseDataService = new FirebaseDataFunc(null);
@override
  void initState() {
    super.initState();
  }
  checkAccountForLogout()async{
   // print('Logout ${userModel.accountType}');
    if(userModel.accountType==USER_ACCOUNT_FACEBOOK){
      logOutFacebook();
    }else if(userModel.accountType==USER_ACCOUNT_GMAIL){
      logoutGoogle();
    }else{
      print('unknow type');
    }
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
  }
  //AppLifecycleState state;
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
  //   state = appLifecycleState;
  //   print(state);
  //   print("::");
  //   print('state $state');
  //   super.didChangeAppLifecycleState(state);
  //   // These are the callbacks
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //     // widget is resumed
  //       print('on resume');
  //       break;
  //     case AppLifecycleState.inactive:
  //     // widget is inactive
  //       print('on inactive');
  //       break;
  //     case AppLifecycleState.paused:
  //     // widget is paused
  //       print('on paused');
  //       break;
  //     case AppLifecycleState.detached:
  //       print('on detached');
  //       // widget is detached
  //       break;
  //   }
  // }
//}