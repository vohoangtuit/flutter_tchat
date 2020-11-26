import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/progressbar.dart';

import 'dialog.dart';
typedef Int2VoidFunc = void Function(String);
abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
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
    initConfig();
    configData();
  }
  void initConfig()async{
    if(!onStart){
      baseStatefulState=this;
      fireBaseStore = FirebaseFirestore.instance;
      progressBar = ProgressBar();



      //---
      onStart =true;

    }
  }
  void configData()async{
    //-- todo: database change  reRunning rebuild
    tChatAppDatabase = await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    //  setState(() {
    userDao = tChatAppDatabase.userDao;
    messageDao =tChatAppDatabase.messageDao;
    //});
    if(userModel==null){
      getUserInfo();
    }
  }

  void getUserInfo()async{
   await userDao.getSingleUser().then((value) {
   setState(() {
   userModel =value;
  // print('Base  '+userModel.toString());
   });
   });
  }
  @override
  void dispose() {
    progressBar.hide();
    super.dispose();
  }
  void showLoading() {
    progressBar.show(context);
  }

  void hideLoading() {
    progressBar.hide();
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


