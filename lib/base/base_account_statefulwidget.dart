import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';

import 'bases_statefulwidget.dart';

abstract class AccountBaseState <T extends StatefulWidget> extends BaseStatefulWidget{// with WidgetsBindingObserver

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  FirebaseDatabaseMethods firebaseDatabaseMethods = new FirebaseDatabaseMethods();


@override
  void initState() {
    super.initState();
   // WidgetsBinding.instance.addObserver(this);
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