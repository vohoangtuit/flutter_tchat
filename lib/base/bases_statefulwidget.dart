import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/database/last_message_dao.dart';
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/main_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/progressbar.dart';

import '../main.dart';
import '../my_router.dart';
import 'base_dialog.dart';
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
  UserModel myAccount;
  MessageDao messageDao;
  LastMessageDao lastMessageDao;
  String languageCode ='';
  int routeOpening=0;
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

  void updateRouteOpening(int route){
    if(mounted){
      setState(() {
        routeOpening =route;

      });
    }

  }
  Future<UserModel>getAccount() async{
   Map<String, dynamic> userShared;
   final String userStr = await SharedPre.getStringKey(SharedPre.sharedPreUSer);
   if (userStr != null) {
     userShared = jsonDecode(userStr) as Map<String, dynamic>;
   }
   if (userShared != null) {
     if(this.mounted){
       setState(() {
         myAccount = UserModel.fromJson(userShared);
         return myAccount;
       });
     }
   }
   return myAccount;
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


   initDataBase()async{
    //-- todo: database change  reRunning rebuild
    tChatAppDatabase = await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    userDao = tChatAppDatabase.userDao;
    messageDao =tChatAppDatabase.messageDao;
    lastMessageDao =tChatAppDatabase.lastMessageDao;

   // getUserAccount();
    await SharedPre.getStringKey(SharedPre.sharedPreLanguageCode).then((value) {
      if(this.mounted){
        setState(() {
          languageCode =value;
        });
      }
    });
  }
   getUserAccountDatabase()async{
    String id='';
    if(myAccount==null){
      await SharedPre.getStringKey(SharedPre.sharedPreID).then((value){
        id =value;
      });
      if(userDao==null){
        print('userDao null');
        await  initDataBase();
      }
      await userDao.findUserById(id).then((value) {
        if(value!=null){
          setState(() {
            myAccount =value;
            onStart =true;
          });
          ProviderController(context).setMyAccount(myAccount);
        }
      });
    }
  }
  void updateLastMessageByID(LastMessageModel message) async{
   await lastMessageDao.getLastMessageById(message.idReceiver).then((value){
      if(value!=null){
        message.idDB =value.idDB;
        lastMessageDao.updateLastMessageById(message).then((value) {
        });
      }else{
          lastMessageDao.insertMessage(message).then((value) => {
          });
      }
    });
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
  void openScreenWithName(Widget screen){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>screen));
  }
 updateUserDatabase(UserModel user){
    if(userDao!=null){
      userDao.updateUser(user);
      setState(() {
        myAccount =user;
      });
    }
  }
  openMyAppAndRemoveAll(){
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
  }
  openMainScreen(bool synData){
    Navigator.pushNamedAndRemoveUntil(context, TAG_MAIN_SCREEN, (route) => false,arguments: synData);
  }
}


