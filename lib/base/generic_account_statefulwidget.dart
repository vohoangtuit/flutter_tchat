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
import 'package:tchat_app/models/notification/response/response_data.dart';
import 'package:tchat_app/models/notification/response/notification_response.dart';
import 'package:tchat_app/models/notification/response/notification.dart';
import 'file:///C:/TU/Develop/Demo/flutter_tchat/lib/models/notification/sent/data_sent.dart';
import 'file:///C:/TU/Develop/Demo/flutter_tchat/lib/models/notification/sent/sent_notification.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/screens/friends/user_profile_screen.dart';

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

  @override
  void initState() {
    super.initState();

    initNotification();
    //  _subscribeToNamelessCoder();
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
          DataResponse data;
          if(Platform.isIOS){
            data = DataResponse.fromJsonIOS(message);
          }else{
            data = DataResponse.dataFromJson(message);
          }
          ResponseNotification responseNotification =  ResponseNotification(notification:pushNotification,dataNotification:data);
          gotoDetailScreen(data);
        });
      },

      onResume: (Map<String, dynamic> message)async{
        print("onResume $message");
        NotificationResponse pushNotification = NotificationResponse.fromJson(message);

        DataResponse data;
        if(Platform.isIOS){
          data = DataResponse.fromJsonIOS(message);
        }else{
          data = DataResponse.dataFromJson(message);
        }
        ResponseNotification responseNotification =  ResponseNotification(notification:pushNotification,dataNotification:data);
        gotoDetailScreen(data);
      },
      onMessage: (Map<String, dynamic> message)async{
        setState(() {
          print("onMessage "+message.toString());
          NotificationResponse pushNotification = NotificationResponse.fromJson(message);
          // print("PushNotification 1: "+pushNotification.title);
          DataResponse data;
          if(Platform.isIOS){
            data = DataResponse.fromJsonIOS(message);
          }else{
            data = DataResponse.dataFromJson(message);
          }
          ResponseNotification responseNotification =  ResponseNotification(notification:pushNotification,dataNotification:data);
          _showNotification(responseNotification);

        });
      },
    );

    registerFBToken();
  }
  Future<String> registerFBToken()async{
    if (userModel == null) {
      await getAccount();
      // if(userModel.pushToken.isEmpty){
      firebaseMessaging.getToken().then((token) {
        print('token: $token');
        userModel.pushToken = token;
        updateUserDatabase(userModel);
        fireBaseStore
            .collection(FIREBASE_USERS)
            .doc(userModel.id)
            .update({USER_PUST_TOKEN: token});
      }).catchError((err) {
        print('Error Token');
      });
      //  }
    }
  }
  Future _showNotification(ResponseNotification responseNotification) async {/// todo: khi app opening thì sẽ vào đây
 //   print("_showNotification :  "+responseNotification.toString());
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High,autoCancel: true);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    DataResponse data = responseNotification.dataNotification;
    await flutterLocalNotificationsPlugin.show(
        5, responseNotification.notification.title, responseNotification.notification.body, platformChannelSpecifics,
        payload: responseNotification.dataNotification.toString());
   // print('data '+data.toString());
  }
  Future onSelectNotification(String payload) async {//todo: convert model to json rồi gửi qua screen khác, vì ko gửi model dc
    DataResponse dataNotification;
    if (payload != null) {
      print(' payload: ' + payload);
      var jsonData = json.decode(payload).toString();
      print(' jsonData: ' + jsonData.toString());
       dataNotification =DataResponse.fromJson(jsonData);
      print(' dataNotification: ' + dataNotification.title);
    }
    // await Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (context) => new DetailPage(payload)),ModalRoute.withName('/'));
    await gotoDetailScreen(dataNotification);
  }
  gotoDetailScreen(DataResponse data)async{
    print('data detail'+data.toString());
    if(data==null){
      return;
    }

    switch (data.type) {
      case 1:
        UserModel user =await getUserProfile(data.uid);
        openScreen(ChatScreen(user));
        break;
      case 2:
        UserModel user =await getUserProfile(data.uid);
        openScreen(UserProfileScreen(myProfile:userModel,user: user));
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
    if (userModel.accountType == USER_ACCOUNT_FACEBOOK) {
      logOutFacebook();
    } else if (userModel.accountType == USER_ACCOUNT_GMAIL) {
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
      userModel = null;
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
    DataSent dataNotification = DataSent(
        uid: formId,
        type: NOTIFICATION_TYPE_SEND_ADD_FRIEND,
        title: '',
        content: '');
    SentNotificationModel sent = SentNotificationModel(
        uid: toUid,
        title: nameRequest,
        body: 'Send you request add friend',
        data: dataNotification.toJson());
    fireBaseStore
        .collection(FIREBASE_NOTIFICATIONS)
        .doc(toUid)
        .collection(NOTIFICATION_ADD_FRIEND)
        .add(sent.toJson())
        .then((value) {});
  }

  senNotificationNewMessage(
      String toUid, String nameRequest, String formId, String content) {
    DataSent dataNotification = DataSent(
        uid: formId,
        type: NOTIFICATION_TYPE_NEW_MESSAGE,
        title: '',
        content: content);
    SentNotificationModel sent = SentNotificationModel(
        uid: toUid,
        title: nameRequest,
        body: 'you have got a new message',
        data: dataNotification.toJson());
    fireBaseStore
        .collection(FIREBASE_NOTIFICATIONS)
        .doc(toUid)
        .collection(NOTIFICATION_MESSAGE)
        .add(sent.toJson())
        .then((value) {});
  }

  // registerNotification() async {
  //   if (userModel == null) {
  //     await getAccount();
  //     // if(userModel.pushToken.isEmpty){
  //     firebaseMessaging.getToken().then((token) {
  //       print('token: $token');
  //       userModel.pushToken = token;
  //       updateUserDatabase(userModel);
  //       fireBaseStore
  //           .collection(FIREBASE_USERS)
  //           .doc(userModel.id)
  //           .update({USER_PUST_TOKEN: token});
  //     }).catchError((err) {
  //       print('Error Token');
  //     });
  //     //  }
  //   }
  //   firebaseMessaging.requestNotificationPermissions();
  //   firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
  //     //print('onMessage: $message');
  //     Platform.isAndroid
  //         ? showNotification(message)
  //         : showNotification(message);
  //     handleNotifications(message);
  //     return;
  //   }, onResume: (Map<String, dynamic> message) {
  //     // print('onResume: $message');
  //     handleNotifications(message);
  //     return;
  //   }, onLaunch: (Map<String, dynamic> message) {
  //     //   print('onLaunch: $message');
  //     handleNotifications(message);
  //     return;
  //   });
  // }
  //
  // void configLocalNotification() {
  //   var initializationSettingsAndroid =
  //       new AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initializationSettingsIOS = new IOSInitializationSettings();
  //   var initializationSettings = new InitializationSettings(
  //       initializationSettingsAndroid, initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: onSelectNotification);
  // }
  //
  // Future _showNotification(SentNotificationModel responseNotification) async {
  //   /// todo: khi app opening thì sẽ vào đây
  //   //print("responseNotification:  "+responseNotification.toJson().toString());
  //   DataNotification data =
  //       DataNotification.dataFromJson(responseNotification.data);
  //
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       importance: Importance.Max, priority: Priority.High, autoCancel: true);
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.show(5, responseNotification.title,
  //       responseNotification.body, platformChannelSpecifics,
  //       payload: responseNotification.data['']);
  // }
  //
  // Future showNotification(Map<String, dynamic> message) async {
  //   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
  //     Platform.isAndroid ? 'vht.tchat.com' : 'vht.tchatapp.com',
  //     'Flutter chat demo',
  //     'your channel description',
  //     playSound: true,
  //     enableVibration: true,
  //     importance: Importance.Max,
  //     priority: Priority.High,
  //   );
  //   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  //   var platformChannelSpecifics = new NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   //print('message $message');
  //   await flutterLocalNotificationsPlugin.show(
  //       5,
  //       message['notification']['title'].toString(),
  //       message['notification']['body'].toString(),
  //       platformChannelSpecifics,
  //       payload: json.encode(message));
  // }
  //
  // handleNotifications(Map<String, dynamic> message) async {
  //
  // }
  //
  // Future onSelectNotification(String payload) async {
  //   //todo: convert model to json rồi gửi qua screen khác, vì ko gửi model dc
  //   if (payload != null) {
  //     print('notification payload: ' + payload);
  //   }
  //   // DataNotification data =DataNotification.dataFromJson(message);
  //   // print('notificationModel ${data.uid}');
  //   // if(data.type==1){
  //   //   UserModel user =await getUserProfile(data.uid);
  //   //   openScreen(ChatScreen(user));
  //   //   //  Navigator.push(, MaterialPageRoute(builder: (context)=>screen));
  //   // }else if(data.type==2){
  //   //   UserModel user =await getUserProfile(data.uid);
  //   //   openScreen(UserProfileScreen(myProfile:userModel,user: user));
  //   // }
  //   // await Navigator.pushAndRemoveUntil(context,
  //   //     MaterialPageRoute(builder: (context) => new DetailPage(payload)),ModalRoute.withName('/'));
  // }

  Future<UserModel> getUserProfile(String uid) async {
    setState(() {
      isLoading = true;
    });
    firebaseDataService.getInfoUserProfile(uid).then((value) {
      if (value.data() != null) {
        Map<String, dynamic> json = value.data();
        UserModel userModel = UserModel.fromJson(json);
        setState(() {
          isLoading = false;
        });
        return userModel;
      } else {
        setState(() {
          isLoading = false;
        });
        return null;
      }
    });
  }
}
