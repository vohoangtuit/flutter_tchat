import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';

import 'bases_statefulwidget.dart';

abstract class AccountBaseState <T extends StatefulWidget> extends BaseStatefulWidget{

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  FirebaseDatabaseMethods firebaseDatabaseMethods = new FirebaseDatabaseMethods();

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   return super.build(context);
  // }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }
}