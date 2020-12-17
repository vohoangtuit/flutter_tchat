import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/screens/items/item_users.dart';
import 'package:tchat_app/screens/account/update_account_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/loading.dart';
import 'package:tchat_app/widget/text_style.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/widget/toolbar_main.dart';
import '../../main.dart';

class UsersScreen extends StatefulWidget {
  @override
  State createState() => UsersScreenState();
}

class UsersScreenState extends AccountBaseState<UsersScreen> with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  List<UserModel> listUser = List();
  Stream streamUsers;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: userList(),
          ),
        ],
      ),
    );
  }

  getData() async {

    firebaseDataService.getAllUser().then((data) {
      setState(() {
        streamUsers = data;
      });
      hideLoading();
    });

  }

  Widget userList() {
    return StreamBuilder(
      stream: streamUsers,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(4.0),
                itemCount: snapshot.data.documents.length,
                // snapshot.data.documents.length
                itemBuilder: (context, index) => ItemUser(
                    context, snapshot.data.documents[index], userModel,false),
              )
            : Container();
      },
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
