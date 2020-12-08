import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/utils/time_ago.dart';
import 'package:tchat_app/widget/drawhorizontalline.dart';
import 'package:tchat_app/widget/text_style.dart';

import '../chat_screen.dart';

Widget buildItemLastMessage(BuildContext context,UserModel userModel, LastMessageModel message,String languageCode) {
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
                message.photoReceiver.isEmpty?Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: greyColor,
                ):ClipRRect(
                    borderRadius: BorderRadius.circular(32.0),
                    child: Image.network(message.photoReceiver,width: 50,height: 50,)),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0,top: 0.0,right: 40.0,bottom: 0.0),
                    child: Column(
                     // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message.nameReceiver,style: normalTextBlack(), overflow: TextOverflow.ellipsis, maxLines: 1,),
                        SizedBox(height: 5,),
                        Text(getContent(message),style: smallTextGray()),
                      ],

                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
               child: (Text(TimeAgo().timeAgo(languageCode,TimeAgo().getDateTimeFromString(message.timestamp)),style: smallerTextGray())),
              //child: (Text('Update: ',style: smallTextGray())),
            )
          ],
        ),
      ),
      onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(message.idReceiver, message.photoReceiver, message.nameReceiver
                )));
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
