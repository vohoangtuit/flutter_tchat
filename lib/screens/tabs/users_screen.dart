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
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/setting_screen.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/loading.dart';
import 'package:tchat_app/widget/text_style.dart';

import '../chat_screen.dart';
import '../main.dart';
class UsersScreen extends StatefulWidget {

  @override
  State createState() => UsersScreenState();
}

class UsersScreenState extends BaseStatefulState<UsersScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Flexible(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                // List
                Container(
                  child: StreamBuilder(
                    stream:
                    fireBaseStore.collection(FIREBASE_USERS).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                        );
                      } else {
                        if(idMe==null){
                          return Text("hello");
                        }else{
                          return ListView.builder (
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10.0),
                              itemBuilder: (context, index) =>
                                  buildItem(context, snapshot.data.documents[index]),
                              itemCount: snapshot.data.documents.length,
                          );
                        }

                      //
                      }
                    },
                  ),
                ),

                // Loading
                Positioned(
                  child: isLoading ? const Loading() : Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document.data()[USER_ID] == idMe) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document.data()[USER_PHOTO_URL] != null
                    ? CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ),
                  imageUrl: document.data()[USER_PHOTO_URL],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: greyColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Full Name: ${document.data()[USER_FULLNAME]}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'Email: ${document.data()[USER_EMAIL] ?? '.....'}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                       document.id,
                       document.data()[USER_PHOTO_URL],
                        document.data()[USER_FULLNAME]
                    )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

