import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/account/base_account_update.dart';
import 'package:tchat_app/screens/main_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:tchat_app/widget/button/button_login.dart';

import 'package:tchat_app/widget/loading.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends BaseAccountUpdate<LoginScreen> {


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWithTitle(
        context,'Login Account'),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonLogin(icon:'images/icons/ic_google.png',title: 'Login with Google',onPressed: (){
                    signInGoogle();
                  },),
                  SizedBox(height: 20,),
                  ButtonLogin(icon:'images/icons/ic_facebook.png',title: 'Login with Facebook',onPressed: (){
                    signInFacebook();
                  },),
                ],
              ),
            ),
            Positioned(
              child: isLoading ? const LoadingCircle() : Container(),
            ),
          ],

        ));

  }
  Future<Null> signInGoogle() async {
    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount googleUser = await googleSignIn.signIn().catchError((onError){
      print("onError $onError");
    });
    if(googleUser!=null){
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential=  GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //registerAuthCredential(credential);
      User firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
      registerAuthCredential(firebaseUser,USER_ACCOUNT_GMAIL);
    }else{
      print("GoogleSignInAccount in null");
          this.setState(() {
            isLoading = false;
            return;
          });
    }

  }

  signInFacebook()async{
    this.setState(() {
      isLoading = true;
    });
    final result = await facebookLogin.logIn(['email']);
    if(result!=null){
      switch(result.status){
        case FacebookLoginStatus.loggedIn:

          _sendTokenToServer(result.accessToken.token);
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('FacebookLoginStatus cancel');
          setState(() {
            isLoading =false;
          });
          break;
        case FacebookLoginStatus.error:
          print('FacebookLoginStatus error');
          setState(() {
            isLoading =false;
          });
          break;
      }
    }else{
      this.setState(() {
        isLoading = false;
      });
    }

  }
  _sendTokenToServer(String token) async{
    // todo
    print("FB Token $token");
     AuthCredential credential =  FacebookAuthProvider.credential(token);
    User firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
    registerAuthCredential(firebaseUser,USER_ACCOUNT_FACEBOOK);
    //_getFBProfile(token);
  }
  registerAuthCredential(User firebaseUser,int accountType) async{
    //final firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;// todo đăng ký trên firebase từ facebook token
    if(firebaseUser!=null){
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(FIREBASE_USERS)
        .where(FIREBASE_ID, isEqualTo: firebaseUser.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    UserModel user;
    if (documents.length == 0) {
    // Update data to server if new user
      // todo insert data to firebase
    user = UserModel(id:firebaseUser.uid, userName:'', fullName:firebaseUser.displayName, birthday:'',gender: 0,email:firebaseUser.email, photoURL:firebaseUser.photoURL,cover: '', statusAccount:0, phoneNumber:'',createdAt:DateTime.now().millisecondsSinceEpoch.toString(),lastUpdated: DateTime.now().millisecondsSinceEpoch.toString(),pushToken:'',isLogin:true,accountType: accountType,allowSearch: true,latitude: 0.0,longitude: 0.0);
    FirebaseFirestore.instance
        .collection(FIREBASE_USERS)
        .doc(firebaseUser.uid)
        .set(user.toJson());
    // Write data to local
    currentUser = firebaseUser;
    await SharedPre.saveBool(SharedPre.sharedPreIsLogin,true);
    await SharedPre.saveString(SharedPre.sharedPreID,currentUser.uid);

    } else {
    // Write data to local
    await SharedPre.saveBool(SharedPre.sharedPreIsLogin,true);
    await SharedPre.saveString(SharedPre.sharedPreID,documents[0].data()[USER_ID]);

    //todo get data from firebase
    Map<String, dynamic> json = documents[0].data();// todo: chuyển data sang json để check field exits, nếu ko thì document ko thể check field exits
    user= UserModel.fromJson(json);
    //user= UserModel.fromDocumentSnapshot(documents[0]);


    }

   // await SharedPre.saveInt(SharedPre.sharedPreAccountType, accountType);
    saveAccountToShared(user);
    this.setState(() {
    isLoading = false;
    });
    ProviderController(context).setAccount(user);
    openMainScreen(true);
    }else{
    this.setState(() {
    isLoading = false;
    Fluttertoast.showToast(msg: "registerAuthCredential  fail ");
    });
    }
  }

  @override
  void callBackCamera(File file, type) {

  }

  @override
  void updateProfile(UserModel user, bool success) {

  }

  @override
  void callBackLibrary(File file, type) {
    // TODO: implement callBackLibrary
  }

}
