import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/models/account_model.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/utils/time_ago.dart';
import 'package:tchat_app/widget/drawhorizontalline.dart';
import 'package:tchat_app/widget/text_style.dart';
import 'package:tchat_app/widget/widget.dart';

import '../chat_screen.dart';

Widget buildItemLastMessage(BuildContext context,AccountModel userModel, LastMessageModel message,String languageCode) {
  return Container(
    child: FlatButton(
      padding: EdgeInsets.only(left: 10.0,top: 0.0,right: 5.0,bottom: 0.0),
      child: Padding(
        padding: EdgeInsets.only(left: 0.0,top: 8.0,right: 0.0,bottom: 10.0),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                 // child:  CircleAvatar(radius: 30.0, backgroundImage: message.photoReceiver.isEmpty ? AssetImage(PATH_AVATAR_NOT_AVAILABLE):NetworkImage(message.photoReceiver), backgroundColor: Colors.transparent,),
                  child: message.photoReceiver.isEmpty?CircleAvatar(radius: 30.0,backgroundImage:AssetImage(PATH_AVATAR_NOT_AVAILABLE)):Material(
                    child: cachedImage(message.photoReceiver,45.0,45.0),
                    borderRadius: BorderRadius.all(
                        Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  width: 45,height: 45,
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0,top: 0.0,right: 40.0,bottom: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message.nameReceiver,style: textBlackNormal(), overflow: TextOverflow.ellipsis, maxLines: 1,),
                        SizedBox(height: 5,),
                        Text(getContent(message),style: textGraysSmall()),
                      ],

                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
               child: (Text(TimeAgo().timeAgo(languageCode,TimeAgo().getDateTimeFromString(message.timestamp)),style: textGraySmaller())),
              //child: (Text('Update: ',style: smallTextGray())),
            )
          ],
        ),
      ),
      onPressed: (){
        AccountModel toUser =AccountModel();
        toUser.id =message.idReceiver;
        toUser.fullName =message.nameReceiver;
        toUser.photoURL =message.photoReceiver;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(toUser)));
      },
    ),
  );
}

String getContent(LastMessageModel mgs) {
  if(mgs.type==0){
    return mgs.content;
  }else if(mgs.type==1){
    return '[Photo]';
  }
  return '[Sticker]';
}
