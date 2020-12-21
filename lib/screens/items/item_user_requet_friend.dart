import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/utils/time_ago.dart';
import 'package:tchat_app/widget/text_style.dart';
import 'package:tchat_app/widget/widget.dart';

Widget ItemUserRequest(BuildContext context, FriendModel friendModel,UserModel userModel,String languageCode,ValueChanged actionClick) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
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
          child: Row(children: [
            SizedBox(width: 10,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      friendModel.fullName,
                      style: textBlackMedium(),
                      overflow: TextOverflow.ellipsis,
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  ),
                  //Text('2 hours ago',style: textGraysSmall(),),
                  Text(friendModel.timeRequest!=null?TimeAgo().timeAgo(languageCode,TimeAgo().getDateTimeFromString(friendModel.timeRequest)):'',style: textGraySmaller())
                ],
              ),
            ),
            InkWell(
              child: textBackGroundRadius(Colors.lightBlue,'Accept',textBlackSmall()),
              onTap: (){
                print('Accept');
                friendModel.actionConfirm =FRIEND_ACCTION_CLICK_ACCEPT;
                actionClick(friendModel);
              },
            ),
            SizedBox(width: 5,),
            InkWell(
              child: Icon(Icons.close,size: 20,),
              onTap: (){
                print('DELETE');
                friendModel.actionConfirm =FRIEND_ACCTION_CLICK_DENNY;
                actionClick(friendModel);
              },
            ),
          ],
          ),
        ),
      ],
    ),
  );
}