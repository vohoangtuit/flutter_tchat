import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/bloc/account_bloc.dart';
import 'package:tchat_app/bloc/reload_messsage_bloc.dart';
import 'package:tchat_app/database/database.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/screens/items/item_last_message.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/text_style.dart';

class LastMessageScreen extends StatefulWidget  {
   bool loadData ;
  LastMessageScreen({this.loadData});
  @override
  _LastMessageScreenState createState() => _LastMessageScreenState();
}

class _LastMessageScreenState extends BaseStatefulState<LastMessageScreen> with AutomaticKeepAliveClientMixin<LastMessageScreen>  {
  //
  @override
//  TODO: implement wantKeepAlive
 bool get wantKeepAlive => true;

  List<LastMessageModel> listMessage = List();
  AccountBloc accBloc;
  ReloadMessage loadBloc;
  bool isLoad;
  @override
  Widget build(BuildContext context) {
     print('BuildContext');
    Provider.of<AccountBloc>(context,listen: false);
     Provider.of<ReloadMessage>(context,listen: false);
    return Container(
      child: listView(),
    );
  }
  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    if (!isLoad) {
      accBloc =   Provider.of<AccountBloc>(context,listen: false);
      loadBloc = Provider.of<ReloadMessage>(context, listen: false);
      isLoad =true;
    }else{
      print('isload 1 $isLoad');
      if(accBloc.getAccount()!=null){
        setState(() {
          isLoad =true;
        });
        init();
        print('isload 2 $isLoad');
      }else{
        setState(() {
          isLoad =false;
        });
        //print('account bloc is null');
      }
   }


    super.didChangeDependencies();
  }
  @override
  void initState() {
    print('initState');
    isLoad =false;
    super.initState();
   // if(isLoad){
   //   init();
   // }
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
    print('init()');
    await lastMessageDao.getSingleLastMessage().then((value) {
      listMessage.clear();
      setState(() {
        listMessage.addAll(value);
      });
    });
    setState(() {
      isLoad =false;
    });
    loadBloc.setReload(false);
  }
  @override
  void dispose(){
    super.dispose();
  }
}
