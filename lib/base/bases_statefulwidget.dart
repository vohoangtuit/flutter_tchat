import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/bloc/account_bloc.dart';
import 'package:tchat_app/bloc/reload_messsage_bloc.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/database/last_message_dao.dart';
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/tabs/last_message_screen.dart';
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
  LastMessageDao lastMessageDao;

  bool newMessage =false;
  FirebaseDatabaseMethods firebaseDatabaseMethods = new FirebaseDatabaseMethods();
  // AccountBloc accountBloc;
  // ReloadMessage reloadMessage;
  @override
  Widget build(BuildContext context) {
    // Provider.of<AccountBloc>(context);
    // Provider.of<ReloadMessage>(context);
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
  }
  // // @override
  // void dispose(){
  //   super.dispose();
  //   if(progressBar!=null){
  //     progressBar.hide();
  //   }
  // }
  void updateLastMessageByID(LastMessageModel message) async{
   var reloadMessage_ = Provider.of<ReloadMessage>(context, listen: false);
   await lastMessageDao.getLastMessageById(message.idReceiver).then((value){
     // print("value "+value.toString());
      if(value!=null){
        message.idDB =value.idDB;
        lastMessageDao.updateLastMessageById(message).then((value) {
        });
        reloadMessage_.setReload(true);
      }else{
          lastMessageDao.insertMessage(message).then((value) => {

          });
          reloadMessage_.setReload(true);
      }
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!onStart){
      initConfig();
    }

  }

  void initConfig()async{
    progressBar = ProgressBar();
    // accountBloc =   Provider.of<AccountBloc>(context,listen: false);
    // reloadMessage = Provider.of<ReloadMessage>(context, listen: false);
   // configData();
    baseStatefulState=this;
    fireBaseStore = FirebaseFirestore.instance;
    onStart =true;
  }
  void configData()async{
     var accBloc = Provider.of<AccountBloc>(context,listen: false);
    // var reloadMessage_ = Provider.of<ReloadMessage>(context, listen: false);
    //-- todo: database change  reRunning rebuild
    tChatAppDatabase = await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    userDao = tChatAppDatabase.userDao;
    messageDao =tChatAppDatabase.messageDao;
    lastMessageDao =tChatAppDatabase.lastMessageDao;

    await userDao.getSingleUser().then((value) {
      setState(() {
      userModel =value;
       // print('Base  '+userModel.toString());
       });
      accBloc.setAccount(userModel);
    });

   // reloadMessage_.setReload(true);
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

}


