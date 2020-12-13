import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';

import 'bases_statefulwidget.dart';

abstract class AccountBaseState <T extends StatefulWidget> extends BaseStatefulWidget{

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  FirebaseDatabaseMethods firebaseDatabaseMethods = new FirebaseDatabaseMethods();


  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
  void uploadAvatarCover(UserModel user,bool success);
}