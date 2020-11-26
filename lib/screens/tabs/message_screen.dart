import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends BaseStatefulState<MessageScreen> {
  //with AutomaticKeepAliveClientMixin<MessageScreen>
  //@override
  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive => true;
  dynamic data;

  List<MessageModel> listMessage = List();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: listView(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Widget listView() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index) =>
          buildItemLastMessage(context, listMessage[index]),
      itemCount: listMessage.length == 0 ? 0 : listMessage.length,
    );
  }

  Widget buildItemLastMessage(BuildContext context, MessageModel message) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            getPhoto(message).isEmpty?Icon(
              Icons.account_circle,
              size: 50.0,
              color: greyColor,
            ):Image.network(getPhoto(message),width: 50,height: 50),
            Column(
              children: [
                Text(getName(message)),
                Text(message.content),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getName(MessageModel mgs) {
    String name = '';
    if (mgs.idSender.contains(userModel.id)) {
      name = mgs.nameReceiver!=null?mgs.nameReceiver:'';
      return name;
    } else {
      return name;
    }
  }
  String getContent(MessageModel mgs) {
    if(mgs.type==0){
      return mgs.content;
    }else if(mgs.type==1){
      return '[Photo]';
    }
    return '[Sticker]';
  }
  String getPhoto(MessageModel mgs){
    if (mgs.idSender.contains(userModel.id)) {
      return mgs.photoReceiver;
    }
    return '';
  }

  void init() async {
    // configData();
    tChatAppDatabase =
        await $FloorTChatAppDatabase.databaseBuilder('TChatApp.db').build();
    //  setState(() {
    userDao = tChatAppDatabase.userDao;
    messageDao = tChatAppDatabase.messageDao;

    List<MessageModel> list = List();
    await messageDao.getAllMessage().then((value) {
      setState(() {
        list.addAll(value);
      });
      // print("list "+list.toString());
    });
    print("list " + list.toString());
    if (userDao == null) {
      print('userDao null');
    }
    if (userModel == null) {
      print('MSG Screen  userModel null');
      await userDao.getSingleUser().then((value) {
        setState(() {
          userModel = value;
        });
      });
    }
    // print('MSG Screen  '+userModel.toString());
    await messageDao.getLastMessage().then((value) {
      setState(() {
        listMessage.addAll(value);
        if (listMessage.length > 0) {
          for (MessageModel mgs in listMessage) {
            print('mgs ' + mgs.toString());
          }
        }
      });
    });
  }
}
