import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/full_photo.dart';

Widget ItemChatMessage(BuildContext context,String id,int index, DocumentSnapshot document,List<QueryDocumentSnapshot> listMessage,String avatarReceiver) {
  if (document.data()['idFrom'] == id) {
    // Right (my message)
    return Row(
      children: <Widget>[
        document.data()['type'] == 0
        // Text
            ? Container(
          child: Text(
            document.data()['content'],
            style: TextStyle(color: primaryColor),
          ),
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          width: 200.0,
          decoration: BoxDecoration(
              color: greyColor2,
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              bottom: isLastMessageRight(listMessage,index,id) ? 20.0 : 10.0,
              right: 10.0),
        )
            : document.data()['type'] == 1
        // Image
            ? Container(
          child: FlatButton(
            child: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                  width: 200.0,
                  height: 200.0,
                  padding: EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    color: greyColor2,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    'images/img_not_available.jpeg',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl: document.data()['content'],
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              clipBehavior: Clip.hardEdge,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullPhoto(
                          url: document.data()['content'])));
            },
            padding: EdgeInsets.all(0),
          ),
          margin: EdgeInsets.only(
              bottom: isLastMessageRight(listMessage,index,id) ? 20.0 : 10.0,
              right: 10.0),
        )
        // Sticker
            : Container(
          child: Image.asset(
            'images/${document.data()['content']}.gif',
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          margin: EdgeInsets.only(
              bottom: isLastMessageRight(listMessage,index,id) ? 20.0 : 10.0,
              right: 10.0),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.end,
    );
  } else {
    // Left (peer message)
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              isLastMessageLeft(listMessage,index,id)
                  ? Material(
                child: avatarReceiver!=null?
                    Image.network(avatarReceiver, width: 35,height: 35,fit: BoxFit.cover,)
                    :Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: greyColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                clipBehavior: Clip.hardEdge,
              )
                  : Container(width: 35.0),
              document.data()['type'] == 0
                  ? Container(
                child: Text(
                  document.data()['content'],
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(left: 10.0),
              )
                  : document.data()['type'] == 1
                  ? Container(
                child: FlatButton(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          /// valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                        width: 200.0,
                        height: 200.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: greyColor2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Material(
                            child: Image.asset(
                              'images/img_not_available.jpeg',
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                      imageUrl: document.data()['content'],
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                    BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullPhoto(
                                url: document.data()['content'])));
                  },
                  padding: EdgeInsets.all(0),
                ),
                margin: EdgeInsets.only(left: 10.0),
              )
                  : Container(
                child: Image.asset(
                  'images/${document.data()['content']}.gif',
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
                margin: EdgeInsets.only(
                    bottom: isLastMessageRight(listMessage,index,id) ? 20.0 : 10.0,
                    right: 10.0),
              ),
            ],
          ),

          // Time
          isLastMessageLeft(listMessage,index,id)
              ? Container(
            child: Text(
              DateFormat('dd MMM kk:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      int.parse(document.data()['timestamp']))),
              style: TextStyle(
                  color: greyColor,
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic),
            ),
            margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
          )
              : Container()
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
    );
  }
}
bool isLastMessageLeft(List<QueryDocumentSnapshot> listMessage,int index,String id) {
  if ((index > 0 &&
      listMessage != null &&
      listMessage[index - 1].data()['idFrom'] == id) ||
      index == 0) {
    return true;
  } else {
    return false;
  }
}

bool isLastMessageRight(List<QueryDocumentSnapshot> listMessage,int index,String id) {
  if ((index > 0 &&
      listMessage != null &&
      listMessage[index - 1].data()['idFrom'] != id) ||
      index == 0) {
    return true;
  } else {
    return false;
  }
}