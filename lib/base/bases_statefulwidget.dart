import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/database/last_message_dao.dart';
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/main_screen.dart';
import 'package:tchat_app/screens/tabs/last_message_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/progressbar.dart';

import '../main.dart';
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
  LastMessageDao lastMessageDao;

  bool newMessage =false;

  String languageCode ='';

  // AccountBloc accountBloc;
  // ReloadMessage reloadMessage;
  @override
  Widget build(BuildContext context) {
    userModel =ProviderController(context).getAccount();
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

   // print('base initState start $onStart');
    // if(!onStart){
    //   initConfig();
    // }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
   // print('base didChangeDependencies start $onStart');
    if(!onStart){
      initConfig();
    }
  }

  void initConfig()async{
   // print('base initConfig');
    progressBar = ProgressBar();
    baseStatefulState=this;
    fireBaseStore = FirebaseFirestore.instance;
    configData();
  }
  void configData()async{
    //-- todo: database change  reRunning rebuild
    tChatAppDatabase = await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    userDao = tChatAppDatabase.userDao;
    messageDao =tChatAppDatabase.messageDao;
    lastMessageDao =tChatAppDatabase.lastMessageDao;
    String id='';
    if(userModel==null){
      await SharedPre.getStringKey(SharedPre.sharedPreID).then((value){
        id =value;
      });
      await userDao.findUserById(id).then((value) {
        if(value!=null){
          setState(() {
            userModel =value;
            onStart =true;
          });
          ProviderController(context).setAccount(userModel);
        }
      });
    }
    await SharedPre.getStringKey(SharedPre.sharedPreLanguageCode).then((value) {
      setState(() {
        languageCode =value;
      });
    });
  }
  // // @override
  // void dispose(){
  //   super.dispose();
  //   if(progressBar!=null){
  //     progressBar.hide();
  //   }
  // }
  void updateLastMessageByID(LastMessageModel message) async{
   await lastMessageDao.getLastMessageById(message.idReceiver).then((value){
     // print("value "+value.toString());
      if(value!=null){
        message.idDB =value.idDB;
        lastMessageDao.updateLastMessageById(message).then((value) {
        });

      }else{
          lastMessageDao.insertMessage(message).then((value) => {
          });
      }
    });
   ProviderController(context).setReloadLastMessage(true);
  }

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

  openMyAppAndRemoveAll(){
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
  }
  openMainScreen(bool removeAll){
    if(removeAll){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainScreen(false)),
              (Route<dynamic> route) => false);
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(false)));
    }
  }
}


