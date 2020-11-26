import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/main_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:tchat_app/widget/loading.dart';

import '../utils/const.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      String id = await SharedPre.getStringKey(SharedPre.sharedPreID);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MainScreen()),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {


    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(FIREBASE_USERS)
          .where(FIREBASE_ID, isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        // Update data to server if new user
        UserModel user = UserModel(firebaseUser.uid, '', firebaseUser.displayName, '',firebaseUser.email, firebaseUser.photoURL, 0, '',DateTime.now().millisecondsSinceEpoch.toString());
        FirebaseFirestore.instance
            .collection(FIREBASE_USERS)
            .doc(firebaseUser.uid)
            .set(user.toJson());
        // Write data to local
        currentUser = firebaseUser;
        await SharedPre.saveBool(SharedPre.sharedPreIsLogin,true);
        await SharedPre.saveString(SharedPre.sharedPreID,currentUser.uid);
        await SharedPre.saveString(SharedPre.sharedPreFullName,currentUser.displayName);
        await SharedPre.saveString(SharedPre.sharedPrePhotoUrl,currentUser.photoURL);
      } else {
        // Write data to local
        await SharedPre.saveBool(SharedPre.sharedPreIsLogin,true);
        await SharedPre.saveString(SharedPre.sharedPreID,documents[0].data()['id']);
        await SharedPre.saveString(SharedPre.sharedPreFullName,documents[0].data()['fullName']);
        await SharedPre.saveString(SharedPre.sharedPrePhotoUrl,documents[0].data()['photoURL']);

      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  //HomeScreen(currentUserId: firebaseUser.uid)));
                 MainScreen()));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWithTitle(
        context,'Login Account'),
        body: Stack(
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'SIGN IN WITH GOOGLE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            ),
          ],
        ));
  }
}
