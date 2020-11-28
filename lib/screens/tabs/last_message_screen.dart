import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/screens/items/item_last_message.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/text_style.dart';

class LastMessageScreen extends StatefulWidget {
  @override
  _LastMessageScreenState createState() => _LastMessageScreenState();
}

class _LastMessageScreenState extends BaseStatefulState<LastMessageScreen> with AutomaticKeepAliveClientMixin<LastMessageScreen> {
  //
  @override
//  TODO: implement wantKeepAlive
 bool get wantKeepAlive => true;
  dynamic data;

  List<MessageModel> listMessage = List();
  bool loadData =false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: listView(),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  void dispose() {
    super.dispose();
  }
  Widget listView() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 5.0,top: 0.0,right: 0.0,bottom: 8.0),
      itemBuilder: (context, index) =>
          buildItemLastMessage(context,userModel, listMessage[index]),
      itemCount: listMessage.length == 0 ? 0 : listMessage.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,height: 0.5,
          indent: 70.0,// padding left
          endIndent: 0,// padding right
        );
      },
    );
  }

  void init() async {
     await Future.delayed(const Duration(seconds: 2), () {
       showLoading();
    });
     hideLoading();
    // if(messageDao==null){
    //   await configData();
    // }
    await messageDao.getLastMessage().then((value) {
      setState(() {
        listMessage.addAll(value);
        // if (listMessage.length > 0) {
        //   for (MessageModel mgs in listMessage) {
        //     print('mgs ' + mgs.toString());
        //   }
        // }
      });
    });
  }

  @override
  void onDetached() {
    print('message screen onDetached');
  }

  @override
  void onInactive() {
    print('message screen onInactive');
  }

  @override
  void onPaused() {
    print('message screen onPaused');
  }

  @override
  void onResumed() {
    print('message screen onResumed');
  }
}