import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/generated/i18n.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/friends/user_profile_screen.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/widget.dart';

import '../chat_screen.dart';

Widget ItemUser(BuildContext context, DocumentSnapshot document,UserModel userModel, bool profile) {
  if (document.data()[USER_ID] ==  userModel.id) {
    return Container();
  } else {
    UserModel friend =UserModel.fromDocumentSnapshot(document);
    return Container(
      child: FlatButton(
        color: greyColor2,
        padding: EdgeInsets.only(left: 5.0,top:5.0,right: 8.0,bottom: 5.0 ),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: <Widget>[
            Material(
              child: document.data()[USER_PHOTO_URL] != null ? CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                  width: 45.0,
                  height: 45.0,
                 // padding: EdgeInsets.all(12.0),
                ),
                imageUrl: document.data()[USER_PHOTO_URL], width: 45.0, height: 45.0, fit: BoxFit.cover,) : avatarNotAvailable(45.0),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Expanded(
              child: Row(
               // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10,),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            document.data()[USER_FULLNAME]+"",
                            style: TextStyle(color: primaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                         width: 30,height: 30,
                          alignment: Alignment.center,
                          child: Image.asset('images/icons/phone_white.png',width: 21,height: 21,color: Colors.blue,),
                        ),
                        onTap: (){
                          print('audio call');
                        },
                      ),SizedBox(width: 10,),
                      InkWell(
                        child: Container(
                          width: 30,height: 30,
                          alignment: Alignment.center,
                          child: Image.asset('images/icons/camera_white.png',width: 22,height: 22,color: Colors.blue,),
                        ),
                        onTap: (){
                          print('video call');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => profile?UserProfileScreen(myProfile:userModel,user: friend,):ChatScreen(friend)));
        },

      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}