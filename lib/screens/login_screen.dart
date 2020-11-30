import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/bloc/account_bloc.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
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

class LoginScreenState extends BaseStatefulState<LoginScreen> {
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
                MainScreen(false)),
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

      UserModel user;
      if (documents.length == 0) {
        // Update data to server if new user
          user = UserModel(id:firebaseUser.uid, userName:'', fullName:firebaseUser.displayName, birthday:'',email:firebaseUser.email, photoURL:firebaseUser.photoURL, statusAccount:0, phoneNumber:'',createdAt:DateTime.now().millisecondsSinceEpoch.toString(),pushToken:'',isLogin:true);
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
        await SharedPre.saveString(SharedPre.sharedPreID,documents[0].data()[USER_ID]);
        await SharedPre.saveString(SharedPre.sharedPreFullName,documents[0].data()[USER_FULLNAME]);
        await SharedPre.saveString(SharedPre.sharedPreFullName,documents[0].data()[USER_PHOTO_URL]);
        await SharedPre.saveString(SharedPre.sharedPrePhotoUrl,documents[0].data()[USER_EMAIL]);
        user = UserModel(id:documents[0].data()[USER_ID], userName:'', fullName:documents[0].data()[USER_FULLNAME], birthday:'',email:documents[0].data()[USER_EMAIL], photoURL:documents[0].data()[USER_PHOTO_URL], statusAccount:0, phoneNumber:'',createdAt:DateTime.now().millisecondsSinceEpoch.toString(),pushToken:'',isLogin:true);

      }
      await userDao.InsertUser(user);
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
        userModel =user;
      });
      Provider.of<AccountBloc>(context,listen: false).setAccount(user);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  //HomeScreen(currentUserId: firebaseUser.uid)));
                 MainScreen(true)));
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
//  @override//                     AppLifecycleState state
//  void didChangeAppLifecycleState(AppLifecycleState state) {//didChangeAppLifecycleState
//    state = state;
//    print(state);
//    print(":::::::");                                         //didChangeAppLifecycleState
//    switch (state) {
//      case AppLifecycleState.resumed:
//        print('Login resumed()');
//
//        break;
//      case AppLifecycleState.inactive:
//        print('Login inactive()');
//
//        break;
//      case AppLifecycleState.paused:
//        print('Login paused()');
//
//        break;
//      case AppLifecycleState.detached:
//        print('Login paused()');
//
//        break;
//
//    }
//  }

}
