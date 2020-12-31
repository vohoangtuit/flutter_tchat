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
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/notification/data_model.dart';
import 'package:tchat_app/models/notification/notification_model.dart';
import 'package:tchat_app/models/notification/response/notification_response.dart';
import 'package:tchat_app/models/notification/sent/notification_sent.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/chat_screen.dart';

import 'package:tchat_app/shared_preferences/shared_preference.dart';

import 'bases_statefulwidget.dart';

abstract class GenericAccountState<T extends StatefulWidget>
    extends BaseStatefulWidget {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final facebookLogin = FacebookLogin();
  FirebaseDataFunc firebaseDataService = new FirebaseDataFunc(null);

  UserModel userProfile;

  @override
  void initState() {
    super.initState();
    initNotification();
  }
  initNotification(){
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async{
        setState(() {
          print("Called onLaunch");
          print("onLaunch $message");
          NotificationResponse pushNotification = NotificationResponse.fromJson(message);
          DataModel data;
          if(Platform.isIOS){
            data = DataModel.fromJsonIOS(message);
          }else{
            data = DataModel.dataFromJson(message);
          }

          gotoDetailScreen(data);
        });
      },

      onResume: (Map<String, dynamic> message)async{
        print("onResume $message");
        NotificationResponse pushNotification = NotificationResponse.fromJson(message);
        NotificationResponse notification =NotificationResponse.fromJson(message);
        DataModel data;
        if(Platform.isIOS){
          data = DataModel.fromJsonIOS(message);
        }else{
          data = DataModel.dataFromJson(message);
        }
        gotoDetailScreen(data);
      },
      onMessage: (Map<String, dynamic> message)async{// todo: new notify handle show banner
        setState(() {
          print("onMessage : : "+message.toString());
          //NotificationModel pushNotification = NotificationModel.fromJson(message);
          NotificationResponse notification =NotificationResponse.fromJson(message);
        //  print("notification 1: "+notification.toString());
          DataModel dataModel;
          if(Platform.isIOS){
            dataModel = DataModel.fromJsonIOS(message);
          }else{
            dataModel = DataModel.dataFromJson(message);
          }
          NotificationModel notificationModel =  NotificationModel(notification: notification,data: dataModel);
          showBannerNotification(notificationModel);
        });
      },
    );

    registerFBToken();
  }
  Future<String> registerFBToken()async{
    if (myAccount == null) {
      await getAccount();
     //if  if(userModel.pushToken.isEmpty){
      firebaseMessaging.getToken().then((token) {
        print('token: $token');
        myAccount.pushToken = token;
        updateUserDatabase(myAccount);
        fireBaseStore
            .collection(FIREBASE_USERS)
            .doc(myAccount.id)
            .update({USER_PUST_TOKEN: token});
      }).catchError((err) {
        print('Error Token');
      });
        }
   // }
  }
  Future showBannerNotification(NotificationModel notification) async {/// todo: khi app opening thì sẽ vào đây
    print("showBannerNotification :  "+notification.toString());
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High,autoCancel: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        5, notification.notification.title, notification.notification.body, platformChannelSpecifics,
        payload: notification.data.toString());
   // print('data '+data.toString());
  }
  Future onSelectNotification(dynamic payload) async {//todo: convert model to json rồi gửi qua screen khác, vì ko gửi model dc
    if (payload != null) {
      handlePayload(payload);

    }
  }
   handlePayload(String payload) async{
    print('payload '+payload);
    var _json = json.decode(payload) as Map;
    DataModel  data = DataModel(uid: _json['uid'].toString(),type: _json['type'] as int,title: _json['title'].toString(),content: _json['content'].toString(),click_action: _json['content']);
    gotoDetailScreen(data);

  }
   gotoDetailScreen(DataModel data)async{
    print('data:'+data.toString());
    if(data==null){
      return;
    }
    // if(data.type==1){
    //   print('case 1');
    //   Future.delayed(Duration.zero, () async {
    //     await getUserProfile(data.uid);
    //     if(toUser!=null){
    //       openScreen(ChatScreen(toUser));
    //       return;
    //     }
    //   });
    //
    // }else if(data.type==2){
    //   print('case 2');
    // }
    switch (data.type) {
      case 1:
        print('case 1');
        Future.delayed(Duration.zero, () async {
          openScreen(ChatScreen(data.uid));
        });
        break;
      case 2:
       // UserModel user =await getUserProfile(data.uid);
       // openScreen(UserProfileScreen(myProfile:userModel,user: user));
        break;
      default:
        break;
    }
  }
  _subscribeToNamelessCoder() async {
    firebaseMessaging.subscribeToTopic('notifications').then((_) {
      if (mounted) {
        print('notifications subscribeToTopic');
        setState(() {
          // _subscribed = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        print('_subscribeToNamelessCoder ' + error.toString());
        setState(() {
          // _subscribed = false;
        });
      }
    });
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

  sentNotificationRequestAddFriend(
      String toUid, String nameRequest, String formId) {
    DataModel data = DataModel(uid: formId, type: NOTIFICATION_TYPE_SEND_ADD_FRIEND, title: '', content: '');
    NotificationSent sent = NotificationSent(toUId: toUid, title: nameRequest, body: 'Send you request add friend', data: data.toJson());
    fireBaseStore
        .collection(FIREBASE_NOTIFICATIONS)
        .doc(toUid)
        .collection(NOTIFICATION_ADD_FRIEND)
        .add(sent.toJson())
        .then((value) {});
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
  getUserProfile(String uid) async {
    setState(() {
      isLoading = true;
    });
    firebaseDataService.getInfoUserProfile(uid).then((value) {
      if (value.data() != null) {
        Map<String, dynamic> json = value.data();
        UserModel userModel = UserModel.fromJson(json);
        setState(() {
          isLoading = false;
          userProfile =userModel;
        });
      } else {
        setState(() {
          isLoading = false;
          userProfile =null;
        });
        return null;
      }
    });
  }
}
