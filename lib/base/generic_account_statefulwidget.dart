import 'dart:async';
import 'dart:convert' as JSON;
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/notification/data_model.dart';
import 'package:tchat_app/models/notification/notification_model.dart';
import 'package:tchat_app/models/notification/response/notification_response.dart';
import 'package:tchat_app/models/notification/sent/notification_sent.dart';
import 'package:tchat_app/models/user_model.dart';


import 'package:tchat_app/shared_preferences/shared_preference.dart';

import 'bases_statefulwidget.dart';

abstract class GenericAccountState<T extends StatefulWidget>
    extends BaseStatefulWidget {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  FirebaseDataFunc firebaseDataService = new FirebaseDataFunc(null);
  var reload;
  //bool loadOtherUser =false;
  //UserModel userProfile;

  @override
  void initState() {
    super.initState();
  }

  checkAccountForLogout() async {
    // print('Logout ${userModel.accountType}');
    if (myAccount.accountType == USER_ACCOUNT_FACEBOOK) {
      logOutFacebook();
    } else if (myAccount.accountType == USER_ACCOUNT_GMAIL) {
      logoutGoogle();
    } else {
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
      myAccount = null;
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

  senNotificationNewMessage(String toUid, String nameRequest, String formId, String content) {
    DataModel data = DataModel(uid: formId, type: NOTIFICATION_TYPE_NEW_MESSAGE, title: '', content: content,click_action: 'FLUTTER_NOTIFICATION_CLICK');
    NotificationSent sent = NotificationSent(
        toUId: toUid,
        title: nameRequest,
        body: 'you have got a new message',
        data: data.toJson());
    fireBaseStore
        .collection(FIREBASE_NOTIFICATIONS)
        .doc(toUid)
        .collection(NOTIFICATION_MESSAGE)
        .add(sent.toJson())
        .then((value) {});
  }
  sentNotificationRequestAddFriend(String toUid, String nameRequest, String formId) {
    DataModel data = DataModel(uid: formId, type: NOTIFICATION_TYPE_SEND_ADD_FRIEND, title: '', content: '',click_action: 'FLUTTER_NOTIFICATION_CLICK');
    NotificationSent sent = NotificationSent(toUId: toUid, title: nameRequest, body: 'Send you request add friend', data: data.toJson());
    fireBaseStore
        .collection(FIREBASE_NOTIFICATIONS)
        .doc(toUid)
        .collection(NOTIFICATION_ADD_FRIEND)
        .add(sent.toJson())
        .then((value) {});
  }
  getUserProfile(String uid) async {
    setState(() {
      isLoading = true;
    });
   await firebaseDataService.getInfoUserProfile(uid).then((value) {
      if (value.data() != null) {
        Map<String, dynamic> json = value.data();
        UserModel userModel = UserModel.fromJson(json);
        print('userModel $userModel');
        setState(() {
          isLoading = false;
           // userProfile =userModel;
        });
        ProviderController(context).setOtherAccount(userModel);
      } else {
        setState(() {
          isLoading = false;
        });
        return null;
      }
    });
  }
}
