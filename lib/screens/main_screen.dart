import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tchat_app/base/generic_account_statefulwidget.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/notification/data_model.dart';
import 'package:tchat_app/models/notification/notification_model.dart';
import 'package:tchat_app/models/notification/response/notification_response.dart';
import 'package:tchat_app/models/account_model.dart';
import 'package:tchat_app/screens/setting_screen.dart';
import 'package:tchat_app/screens/tabs/contacts_screen.dart';
import 'package:tchat_app/screens/tabs/group_screen.dart';
import 'package:tchat_app/screens/tabs/last_message_screen.dart';
import 'package:tchat_app/screens/tabs/more_screen.dart';
import 'package:tchat_app/screens/tabs/time_line_screen.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/loading.dart';
import 'package:tchat_app/widget/toolbar_main.dart';
import '../controller/my_router.dart';
import 'dialogs/dialog_controller.dart';

class MainScreen extends StatefulWidget {
  bool synData;

  MainScreen(this.synData);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends GenericAccountState<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  int positionTab = 0;
  ValueChanged data;
  FirebaseDataFunc firebaseDataService = new FirebaseDataFunc(null);
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final GlobalKey<State> _loadingKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0.0),
      color: Colors.lightBlue,
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                //Container(color: Colors.lightBlueAccent,height: 56,),
                //(0,data),
                ToolBarMain(position: positionTab, onClick: (click) {
                  handleClick(click);
                },),
                Expanded(
                  child: Scaffold(
                    // appBar: AppBar(
                    //   // title: Text('TChat '),
                    //   // centerTitle: false,
                    // ),
                    body:
                    TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      // todo: disable swip
                      children: <Widget>[
                        LastMessageScreen(),
                        ContactsScreen(),
                        GroupScreen(),
                        TimeLineScreen(),
                        MoreScreen()
                      ],
                      //children: <Widget>[LastMessageScreen(),UsersScreen(), GroupScreen(), TimeLineScreen(), MoreScreen()],
                      // set the controller
                      controller: tabController,
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
                        labelPadding: EdgeInsets.only(
                            left: 0.0, top: 5.0, right: 0.0, bottom: 0.0),
                        labelStyle: TextStyle(color: Colors.blue, fontSize: 10.5),
                        //,fontFamily: 'Family Name'
                        unselectedLabelStyle: TextStyle(
                            color: Colors.grey, fontSize: 10.5),
                        //,fontFamily: 'Family Name'
                        tabs: listTab(),
                        controller: tabController,
                      ),
                    ),


                  ),
                ),
              ],
            ),
          ),
          isLoading ? LoadingCircle() : Container(),
        ],

      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(handleTabSelection);
    initNotification();


  }
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void handleTabSelection() {
    if(mounted){
      setState(() {
        positionTab = tabController.index;
      });
    }
  }

  handleClick(int click) {
    if (click == MAIN_CLICK_SETTING_TAB_MORE) {
      openScreenWithName(SettingScreen());
    }
    if (click == MAIN_CLICK_EDIT_TAB_TIME_LINE) {
      //showBaseDialog('Edit','tab timeline',);
      DialogController(context).showBaseNotification(
          dialog, 'Edit', 'tab timeline');
    }
    if (click == MAIN_CLICK_NOTIFICATION_TAB_TIME_LINE) {
      // showBaseDialog('notification', 'tab timeline',);
      DialogController(context).showBaseNotification(
          dialog, 'notification', 'tab timeline');
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  void handleSyncData() {
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    tabController.dispose();
    super.dispose();
  }

  List<Tab> listTab() {
    return <Tab>[
      // todo: custom view tabs
      Tab(child: Column(children: [
        SizedBox(height: 3,),
        Icon(Icons.message,
            color: tabController.index == 0 ? Colors.blue : Colors.grey),
        Text("Messages"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 5,),
        Icon(Icons.account_box_outlined,
            color: tabController.index == 1 ? Colors.blue : Colors.grey),
        Text("Contacts"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 5,),
        Icon(Icons.group,
            color: tabController.index == 2 ? Colors.blue : Colors.grey),
        Text("Group"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 5,),
        Icon(Icons.timelapse_outlined,
            color: tabController.index == 3 ? Colors.blue : Colors.grey),
        Text("TimeLine"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 5,),
        Icon(Icons.category_outlined,
            color: tabController.index == 4 ? Colors.blue : Colors.grey),
        Text("More"),
      ],)),
    ];
  }

  initNotification() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_notification_system');
    var initializationSettingsIOS = IOSInitializationSettings();
    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);
    var initializationSettings = InitializationSettings(android:initializationSettingsAndroid, iOS:initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered.listen((
        IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
       // setState(() {
          print("Called onLaunch");
          print("onLaunch $message");
          NotificationResponse pushNotification = NotificationResponse.fromJson(
              message);
          DataModel data;
          if (Platform.isIOS) {
            data = DataModel.dataFromIOS(message);
          } else {
            data = DataModel.dataFromAndroid(message);
          }

          gotoDetailScreen(data);
       // });
      },

      onResume: (Map<String, dynamic> message) async {
        print("onResume $message");
        NotificationResponse pushNotification = NotificationResponse.fromJson(message);
        DataModel data;
        if (Platform.isIOS) {
          data = DataModel.dataFromIOS(message);
        } else {
          data = DataModel.dataFromAndroid(message);
        }
        gotoDetailScreen(data);
      },
      onMessage: (Map<String,
          dynamic> message) async { // todo: new notify handle show banner
       // setState(() {
          print("onMessage " + message.toString());
          //NotificationModel pushNotification = NotificationModel.fromJson(message);
          NotificationResponse notification = NotificationResponse.fromJson(
              message);
          //  print("notification 1: "+notification.toString());
          DataModel dataModel;
          if (Platform.isIOS) {
            dataModel = DataModel.dataFromIOS(message);
          } else {
            dataModel = DataModel.dataFromAndroid(message);
          }
          NotificationModel notificationModel = NotificationModel(
              notification: notification, data: dataModel);

          showBannerNotification(notificationModel);
     //   });
      },
    );

    registerFBToken();
  }

  Future<String> registerFBToken() async {
    account = await getAccountFromSharedPre();
    if (account != null) {
      // if(myAccount.pushToken.isEmpty){
      firebaseMessaging.getToken().then((token) {
        print('token: $token');
        account.pushToken = token;
        updateUserDatabase(account);
        fireBaseStore
            .collection(FIREBASE_USERS)
            .doc(account.id)
            .update({USER_PUST_TOKEN: token});
      }).catchError((err) {
        print('Error Token');
      });
      //}
    }
  }

  Future showBannerNotification(NotificationModel notification) async {
    /// todo: khi app opening thì sẽ vào đây
  //  print("showBannerNotification :  " + notification.toString());
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        notification.data.uid, notification.data.title, notification.data.content,
        importance: Importance.max, priority: Priority.high, autoCancel: true,ticker: 'ticker',
       sound: RawResourceAndroidNotificationSound('sound_notification'),
        playSound: true,
        showWhen: true,
      //  groupKey: notification.data.uid
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const MacOSNotificationDetails macOSPlatformChannelSpecifics = MacOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(android:androidPlatformChannelSpecifics, iOS:iOSPlatformChannelSpecifics,macOS:macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, notification.notification.title, notification.notification.body,
        platformChannelSpecifics,
        payload: notification.data.toString());
    // print('data '+data.toString());

  }

  Future onSelectNotification(dynamic payload) async {
    print('onSelectNotification... ');
    if (payload != null) {
 //     print('payload... ' + payload.toString());
      handlePayload(payload);
    }
  }

  handlePayload(String payload) async {
   // print('handlePayload... ');
    var _json = json.decode(payload) as Map;
    DataModel data = DataModel(uid: _json['uid'].toString(),
        type: _json['type'] as int,
        title: _json['title'].toString(),
        content: _json['content'].toString(),
        click_action: _json['click_action']);
    gotoDetailScreen(data);
  }

  gotoDetailScreen(DataModel data) async {
    print('gotoDetailScreen... ');
    if (data == null) {
      return;
    }
      String current = ModalRoute.of(context).settings.name;
      print('current screen $current');
      switch (data.type) {
        case 1:
          getUserInfoAndOpenScreen(data.uid, TAG_CHAT_SCREEN);
          break;
        case 2:
          getUserInfoAndOpenScreen(data.uid, TAG_USER_PROFILE_SCREEN);
          break;
        default:
          break;
      }


  }

  getUserInfoAndOpenScreen(String userID, String screen) async {
    if(mounted){
      setState(() {
        isLoading = true;
      });
    }
    await firebaseDataService.getInfoUserProfile(userID).then((value) {
      if (value.data() != null) {
        Map<String, dynamic> json = value.data();
        AccountModel userModel = AccountModel.fromJson(json);
        if(Navigator.canPop(context)){
          Navigator.popUntil(context,
            ModalRoute.withName(TAG_MAIN_SCREEN),
          );
        }
        if(screen.compareTo(TAG_USER_PROFILE_SCREEN)==0){
          Navigator.pushNamed(context, screen,arguments:{'myProfile':account,'userProfile':userModel});
        }else{
          Navigator.pushNamed(context, screen,arguments:userModel);
        }
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }
}
