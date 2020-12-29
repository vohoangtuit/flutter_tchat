import 'data_sent.dart';

final String NOTIFICATION_ID='id';
final String NOTIFICATION_TYPE='type';
final String NOTIFICATION_TITLE='title';
final String NOTIFICATION_BODY='body';
final String NOTIFICATION_UID='uid';// todo to userID
final String NOTIFICATION_DATA='data';

final int NOTIFICATION_TYPE_NEW_MESSAGE =1;
final int NOTIFICATION_TYPE_SEND_ADD_FRIEND =2;
final int NOTIFICATION_TYPE_ACCEPT_ADD_FRIEND =3;

final String NOTIFICATION_MESSAGE='messages';
final String NOTIFICATION_ADD_FRIEND='add_friend';
class SentNotificationModel{
  String uid;
  String title;
  String body;
  //DataNotification data;
  Map<String,dynamic> data;
  SentNotificationModel({this.uid,this.title,this.body,this.data});

  SentNotificationModel.fromJson(Map<String, dynamic> json){
    uid = json[NOTIFICATION_UID];
    title = json[NOTIFICATION_TITLE];
    body = json[NOTIFICATION_BODY];
    data = json[NOTIFICATION_DATA];
  }
  factory SentNotificationModel.dataFromJson(Map<String, dynamic> json)=> SentNotificationModel(
      data : json[NOTIFICATION_DATA]
  );
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[NOTIFICATION_UID] = this.uid;
    data[NOTIFICATION_TITLE] = this.title;
    data[NOTIFICATION_BODY] = this.body;
    data[NOTIFICATION_DATA] = this.data;
    return data;
  }

  @override
  String toString() {
    return 'SentNotificationModel{uid: $uid, title: $title, content: $body, data: $data}';
  }
}