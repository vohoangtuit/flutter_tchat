import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/base/account_statefulwidget.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/main_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:tchat_app/widget/button.dart';
import 'package:tchat_app/widget/button_login.dart';
import 'package:tchat_app/widget/loading.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends AccountBaseState<LoginScreen> {

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
              child: isLoading ? const Loading() : Container(),
            ),
          ],

        ));

  }
  Future<Null> signInGoogle() async {
    this.setState(() {
      isLoading = true;
    });
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential credential=  GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //registerAuthCredential(credential);
     User firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
    registerAuthCredential(firebaseUser,USER_ACCOUNT_GMAIL);
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
          break;
        case FacebookLoginStatus.error:
          print('FacebookLoginStatus error');
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
    user = UserModel(id:firebaseUser.uid, userName:'', fullName:firebaseUser.displayName, birthday:'',email:firebaseUser.email, photoURL:firebaseUser.photoURL,cover: '', statusAccount:0, phoneNumber:'',createdAt:DateTime.now().millisecondsSinceEpoch.toString(),pushToken:'',isLogin:true,accountType: accountType,allowSearch: true);
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
    user = UserModel(id:documents[0].data()[USER_ID], userName:'', fullName:documents[0].data()[USER_FULLNAME], birthday:'',email:documents[0].data()[USER_EMAIL], photoURL:documents[0].data()[USER_PHOTO_URL],cover: '', statusAccount:0, phoneNumber:'',createdAt:DateTime.now().millisecondsSinceEpoch.toString(),pushToken:'',isLogin:true,accountType: accountType,allowSearch: true);

    }
    await SharedPre.saveInt(SharedPre.sharedPreAccountType, accountType);

    await userDao.InsertUser(user);
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
  _getFBProfile(String token)async{
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
    final profile = JSON.jsonDecode(graphResponse.body);
    print("profile "+profile.toString());

  }
}
