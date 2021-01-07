import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/widget.dart';

import '../chat_screen.dart';

Widget ItemContact(BuildContext context, UserModel friendModel,UserModel userModel) {
  if (friendModel.id ==  userModel.id) {
    return Container();
  } else {
    UserModel friend =UserModel(id: friendModel.id,fullName: friendModel.fullName,photoURL: friendModel.photoURL);
    return Container(
      child: FlatButton(
        color: Colors.white,
        padding: EdgeInsets.only(left: 0.0,top:5.0,right: 0.0,bottom: 5.0 ),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        child: Row(
          children: <Widget>[
            Material(
              child:friendModel.photoURL != null ? CachedNetworkImage(
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
                imageUrl: friendModel.photoURL, width: 45.0, height: 45.0, fit: BoxFit.cover,) : avatarNotAvailable(45.0),
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
                            friendModel.fullName+"",
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
                          child: Image.asset('images/icons/phone_white.png',width: 20,height: 20,color: Colors.grey,),
                        ),
                        onTap: (){
                          print('audio call');
                        },
                      ),SizedBox(width: 8.0,),
                      InkWell(
                        child: Container(
                          width: 30,height: 30,
                          alignment: Alignment.center,
                          child: Image.asset('images/icons/camera_white.png',width: 20,height: 20,color: Colors.grey,),
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
                  builder: (context) => ChatScreen(friend)));
        },

      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }
}