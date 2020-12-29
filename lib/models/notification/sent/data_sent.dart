
import 'dart:convert';

final String MESSAGE_NOTIFY_UID ='uid';
final String MESSAGE_NOTIFY_TITLE ='title';
final String MESSAGE_NOTIFY_CONTENT ='content';
final String MESSAGE_NOTIFY_TYPE ='type';
final String DATA ='data';
class DataSent{
  String uid;
  int type;
  String title;
  String content;

  DataSent({this.uid,this.type,this.title, this.content});
  factory DataSent.dataFromJson(Map<String, dynamic> message){
    var data= json.decode(message['data']['data']);
    return DataSent(
        title: data[MESSAGE_NOTIFY_TITLE],
        content: data[MESSAGE_NOTIFY_CONTENT],
        type: data[MESSAGE_NOTIFY_TYPE],
        uid: data[MESSAGE_NOTIFY_UID]
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[MESSAGE_NOTIFY_UID] = this.uid;
    data[MESSAGE_NOTIFY_TYPE] = this.type;
    data[MESSAGE_NOTIFY_TITLE] = this.title;
    data[MESSAGE_NOTIFY_CONTENT] = this.content;
    return data;
  }

  @override
  String toString() {
    return 'DataNotification{uid: $uid, type: $type, title: $title, content: $content}';
  }
}