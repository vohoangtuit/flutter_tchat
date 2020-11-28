import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/progressbar.dart';

import 'dialog.dart';
typedef Int2VoidFunc = void Function(String);
abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  BaseDialog  dialog;
 static BaseStatefulState baseStatefulState;
  var  restApi;
  ProgressBar progressBar;
  bool onStart =false;
  FirebaseFirestore fireBaseStore;
  FirebaseFirestore userRef;
  FirebaseFirestore msgRef;

  TChatAppDatabase tChatAppDatabase;
  UserDao userDao;
  UserModel userModel;
  MessageDao messageDao;

  bool newMessage =false;
  FirebaseDatabaseMethods firebaseDatabaseMethods = new FirebaseDatabaseMethods();
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(

        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

   // print('base initState()');
  }
  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if(progressBar!=null){
      progressBar.hide();
    }

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('base resumed()');
        onResumed();
        break;
      case AppLifecycleState.inactive:
        print('base inactive()');
        onPaused();
        break;
      case AppLifecycleState.paused:
        print('base paused()');
        onInactive();
        break;
      case AppLifecycleState.detached:
        print('base paused()');
        onDetached();
        break;

    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initConfig();
  }

  void initConfig()async{
    if(!onStart){
      progressBar = ProgressBar();
      configData();
      baseStatefulState=this;
      fireBaseStore = FirebaseFirestore.instance;
      onStart =true;
    }
  }
  void configData()async{
    //-- todo: database change  reRunning rebuild
    tChatAppDatabase = await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    userDao = tChatAppDatabase.userDao;
    messageDao =tChatAppDatabase.messageDao;

    await userDao.getSingleUser().then((value) {
      setState(() {
      userModel =value;
       // print('Base  '+userModel.toString());
       });
    });
  }
  void onResumed();
  void onPaused();
  void onInactive();
  void onDetached();
  void showLoading() {
    if(progressBar!=null){
      progressBar.show(context);
    }

  }

  void hideLoading() {
    if(progressBar!=null){
      progressBar.hide();
    }

  }

  void baseMethod() {
    // Parent method
  }
  showBaseDialog(String title,String description){
    if(dialog!=null){
      dialog.dismiss();
    }
    dialog = new BaseDialog(title: title, description: description);
    showDialog(
     // barrierDismissible: false,// touch outside dismiss
      context: context,
      builder: (BuildContext context) => dialog
    );
  }

}


