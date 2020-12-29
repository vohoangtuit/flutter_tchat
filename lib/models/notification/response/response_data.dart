
import 'dart:convert';

import 'package:tchat_app/models/notification/response/notification.dart';
import 'package:tchat_app/models/notification/sent/data_sent.dart';

class DataResponse{
  String uid;
  int type;
  String title;
  String content;


  DataResponse({this.uid,this.type,this.title, this.content});

  factory DataResponse.fromResponse(ResponseNotification responseNotification){
    print('responseNotification '+responseNotification.toString());
    return DataResponse(
        type:responseNotification.dataNotification.type,
        content:responseNotification.dataNotification.content,
        uid:responseNotification.dataNotification.uid,
        title:responseNotification.dataNotification.title
    );
  }
  factory DataResponse.dataFromJson(Map<String, dynamic> message){
    var data= json.decode(message['data']['data']);
    return DataResponse(
        title: data[MESSAGE_NOTIFY_TITLE],
        content: data[MESSAGE_NOTIFY_CONTENT],
        type: data[MESSAGE_NOTIFY_TYPE],
        uid: data[MESSAGE_NOTIFY_UID]
    );
  }
  factory DataResponse.fromJson(var data){
   // var data= json.decode(message['data']['data']);
    return DataResponse(
        title: data[MESSAGE_NOTIFY_TITLE],
        content: data[MESSAGE_NOTIFY_CONTENT],
        type: data[MESSAGE_NOTIFY_TYPE],
        uid: data[MESSAGE_NOTIFY_UID]
    );
  }

// var data= json.decode(message['data']['data']);
//   factory DataNotification.fromJson(Map<String,dynamic> json) =>DataNotification(
//
//       type:json['data']['data']['type'],
//       content:json['data']['data']['content'],
//       uid:json['data']['data']['uid'],
//       title:json['data']['data']['title']
//   );
  factory DataResponse.formPayload(Map<String,dynamic> string) =>DataResponse(
    // todo: working on ios
      type:string['type'],
      content:string['content'],
      uid:string['uid'],
      title:string['title']
  );
  factory DataResponse.fromJsonIOS(Map<String,dynamic> json) =>DataResponse(
    // todo: working on ios
      type:json['data']['type'],
      content:json['data']['content'],
      uid:json['data']['uid'],
      title:json['data']['title']
  );
  Map<String, dynamic> toJson() => {
    'type': type,
    'content': content,
    'uid': uid,
    'title': title,
  };

  @override
  String toString() {
    return 'DataNotification{uid: $uid, type: $type, title: $title, content: $content}';
  }
}