import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/controller/bloc/account_bloc.dart';
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
abstract class BaseStatefulWidget<T extends StatefulWidget> extends State<T> {
  BaseDialog  dialog;
 static BaseStatefulWidget baseStatefulState;
  var  restApi;
  ProgressBar progressBar;
  bool onStart =false;
  FirebaseFirestore fireBaseStore;
  FirebaseFirestore userRef;
  FirebaseFirestore msgRef;
  bool isLoading=false;
  TChatAppDatabase tChatAppDatabase;
  UserDao userDao;
  UserModel userModel;
  MessageDao messageDao;
  LastMessageDao lastMessageDao;

  String languageCode ='';

  @override
  Widget build(BuildContext context) {
    //print('base BuildContext ');
    return Stack(
      children: <Widget>[
        Container(
        )
      ],
    );
  }

  @override
  void initState() {
    initConfig();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<UserModel>getAccount() async{
   Map<String, dynamic> userShared;
   final String userStr = await SharedPre.getStringKey(SharedPre.sharedPreUSer);
   if (userStr != null) {
     userShared = jsonDecode(userStr) as Map<String, dynamic>;
   }
   if (userShared != null) {
     setState(() {
       userModel = UserModel.fromJson(userShared);
     });
   }
   return userModel;
  }
  void initConfig()async{
    //print('base initConfig');
    progressBar = ProgressBar();
    baseStatefulState=this;
    fireBaseStore = FirebaseFirestore.instance;
    await SharedPre.getBoolKey(SharedPre.sharedPreIsLogin).then((value){
      if(value==null){
        return;
      }else if(value==false){
        return;
      }else{
        getAccount();
      }
    });
    initDataBase();
  }


  void initDataBase()async{
    //-- todo: database change  reRunning rebuild
    tChatAppDatabase = await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    userDao = tChatAppDatabase.userDao;
    messageDao =tChatAppDatabase.messageDao;
    lastMessageDao =tChatAppDatabase.lastMessageDao;

   // getUserAccount();
    await SharedPre.getStringKey(SharedPre.sharedPreLanguageCode).then((value) {
      setState(() {
        languageCode =value;
      });
    });
  }
  void getUserAccountDatabase()async{
    print('get user');
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
  }
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
 //  ProviderController(context).setReloadLastMessage(true);
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
  void openScreen(Widget screen){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>screen));
  }
 updateUserDatabase(UserModel user){
    if(userDao!=null){
      userDao.updateUser(user);
      setState(() {
        userModel =user;
      });
    }
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


