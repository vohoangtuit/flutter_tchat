import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/tabs/group_screen.dart';
import 'package:tchat_app/screens/tabs/last_message_screen.dart';
import 'package:tchat_app/screens/tabs/more_screen.dart';
import 'package:tchat_app/screens/tabs/time_line_screen.dart';
import 'package:tchat_app/screens/tabs/users_screen.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
class MainScreen extends StatefulWidget {
   bool synData;
  MainScreen( this.synData);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends BaseStatefulState<MainScreen> with SingleTickerProviderStateMixin {
  TabController controller;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('TChat '),
          centerTitle: false,
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),// todo: disable swip
          // children: <Widget>[MessageScreen(),ContactsScreen(), GroupScreen(), TimeLineScreen(), MoreScreen()],
          children: <Widget>[LastMessageScreen(),UsersScreen(), GroupScreen(), TimeLineScreen(), MoreScreen()],
          //   children: <Widget>[UsersScreen(), GroupScreen(), TimeLineScreen(), MoreScreen()],
          // set the controller
          controller: controller,
        ),
        bottomNavigationBar: Material(
          // set the color of the bottom navigation bar
          color: Colors.white,
          // set the tab bar as the child of bottom navigation bar
          child:
          TabBar(
           // indicatorColor: Colors.transparent,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            labelPadding: EdgeInsets.only(left: 0.0,top: 5.0,right: 0.0,bottom: 0.0),
            labelStyle: TextStyle(color:Colors.blue,fontSize: 10.5),//,fontFamily: 'Family Name'
            unselectedLabelStyle: TextStyle(color:Colors.grey,fontSize:10.5),//,fontFamily: 'Family Name'
            tabs:listTab(),
            controller: controller,
          ),
        ),
      );
  }
  @override
  void initState() {
    super.initState();
  //  print('main screen initState()');
    controller = TabController(length: 5, vsync: this);
    controller.addListener(_handleTabSelection);
    if(widget.synData){

    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  void handleSyncData(){

    // StreamBuilder(
    //   stream: fireBaseStore
    //       .collection(FIREBASE_MESSAGES)
    //       .doc( userModel.id)
    //       .snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       print("cannot get data");
    //     } else {
    //       listMessage.addAll(snapshot.data.documents);
    //       return ListView.builder(
    //         padding: EdgeInsets.all(10.0),
    //         itemBuilder: (context, index) =>
    //             ItemChatMessage(context, userModel.id,index,snapshot.data.documents[index],listMessage,widget.photoUrl),
    //         itemCount: snapshot.data.documents.length,
    //         reverse: true,
    //         controller: listScrollController,
    //       );
    //     }
    //   },
    // ),
    // fireBaseStore.collection(FIREBASE_MESSAGES).doc(userModel.id).snapshots().listen((event) {
    //   if(event)
    // });
    // fireBaseStore
    //     .collection(FIREBASE_MESSAGES)
    //     .doc( userModel.id)
    //     .collection("widget.toId")
    //     .orderBy('timestamp', descending: true)
    //     .limit(10)
    //     .snapshots().listen((event) {
    //
    // });
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }
  void _handleTabSelection() {
    setState(() {
    });
  }
  List<Tab> listTab(){
    return <Tab>[
      // todo: custom view tabs
      Tab(child: Column(children: [
        SizedBox(height: 3,),
        Icon(Icons.message, color: controller.index == 0 ? Colors.blue : Colors.grey),
        Text("Messages"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 5,),
        Icon(Icons.account_box_outlined, color: controller.index == 1 ? Colors.blue : Colors.grey),
        Text("Contacts"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 5,),
        Icon(Icons.group, color: controller.index == 2 ? Colors.blue : Colors.grey),
        Text("Group"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 5,),
        Icon(Icons.timelapse_outlined, color: controller.index == 3 ? Colors.blue : Colors.grey),
        Text("TimeLine"),
      ],)),
      Tab(child: Column(children: [
          SizedBox(height: 5,),
          Icon(Icons.category, color: controller.index == 4 ? Colors.blue : Colors.grey),
          Text("More"),
        ],)),
    ];
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      fireBaseStore.collection(FIREBASE_USERS)
          .doc( userModel.id)
          .update({USER_PUST_TOKEN: token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }


}
