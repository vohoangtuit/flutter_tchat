
import 'dart:convert';

final String MESSAGE_NOTIFY_UID ='uid';
final String MESSAGE_NOTIFY_TITLE ='title';
final String MESSAGE_NOTIFY_CONTENT ='content';
final String MESSAGE_NOTIFY_TYPE ='type';
final String MESSAGE_NOTIFY_CLICK_ACTION ='click_action';
final String MESSAGE_NOTIFY_DATA ='data';
class DataModel{
  String uid;
  int type;
  String title;
  String content;
  String click_action;
  DataModel({this.uid,this.type,this.title, this.content,this.click_action});
  factory DataModel.dataFromAndroid(Map<String, dynamic> message){
    var data= json.decode(message['data']['data']);
    //var data= json.decode(message['data']);
    return DataModel(
        uid: data[MESSAGE_NOTIFY_UID],
        type: data[MESSAGE_NOTIFY_TYPE],
        title: data[MESSAGE_NOTIFY_TITLE],
        content: data[MESSAGE_NOTIFY_CONTENT],
        click_action: data[MESSAGE_NOTIFY_CLICK_ACTION],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[MESSAGE_NOTIFY_UID] = this.uid;
    data[MESSAGE_NOTIFY_TYPE] = this.type;
    data[MESSAGE_NOTIFY_TITLE] = this.title;
    data[MESSAGE_NOTIFY_CONTENT] = this.content;
    data[MESSAGE_NOTIFY_CLICK_ACTION] = this.click_action;
    return data;
  }
  factory DataModel.dataFromIOS(Map<String, dynamic> message){
    var data= json.decode(message['data']);
    return DataModel(
      uid: data[MESSAGE_NOTIFY_UID],
      type: data[MESSAGE_NOTIFY_TYPE],
      title: data[MESSAGE_NOTIFY_TITLE],
      content: data[MESSAGE_NOTIFY_CONTENT],
      click_action: data[MESSAGE_NOTIFY_CLICK_ACTION],
    );
  }
  factory DataModel.fromJsonPayload(String payload) {
    var data = json.decode(payload) as Map;
    return DataModel(
        uid:data['uid'],
        type:data['type'],
        title:data['title'],
        content:data['content'],
        click_action:data['click_action']
    );
  }

  // @override
  // String toString() {
  //   return 'DataModel{uid: $uid, type: $type, title: $title, content: $content}';
  // }

@override
  String toString() {
    return '{"uid": "$uid", "type": $type, "title": "$title", "content": "$content","click_action": "$click_action"}';// todo format to payload
  }

}