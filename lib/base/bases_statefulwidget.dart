import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/database/last_message_dao.dart';
import 'package:tchat_app/database/message_dao.dart';
import 'package:tchat_app/database/user_dao.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/account_model.dart';
import 'package:tchat_app/screens/main_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/progressbar.dart';

import '../main.dart';
import '../controller/my_router.dart';
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

  void initConfig()async{
    //print('base initConfig');
    progressBar = ProgressBar();
    baseStatefulState=this;
    fireBaseStore = FirebaseFirestore.instance;
    await SharedPre.getStringKey(SharedPre.sharedPreLanguageCode).then((value) {
      if(this.mounted){
        setState(() {
          languageCode =value;
        });
      }
    });
  }

  void updateLastMessageByID(LastMessageModel message) async{
   await floorDB.lastMessageDao.getLastMessageById(message.idReceiver).then((value){
      if(value!=null){
        message.idDB =value.idDB;
        floorDB.lastMessageDao.updateLastMessageById(message).then((value) {
        });
      }else{
        floorDB.lastMessageDao.insertMessage(message).then((value) => {
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

  openMyAppAndRemoveAll(){
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
  }
  openMainScreen(bool synData){
    Navigator.pushNamedAndRemoveUntil(context, TAG_MAIN_SCREEN, (route) => false,arguments: synData);
  }
}


