
import 'data_model.dart';
import 'response/notification_response.dart';

class NotificationModel{
  NotificationResponse notification;
  DataModel data;
  NotificationModel({this.notification, this.data});
 // factory ResponseNotification.
  factory NotificationModel.fromJson(Map<String, dynamic> json){
    print('NotificationModel json '+json.toString());
   return NotificationModel(
     notification: json['notification'],
      data: json['data']['data'],
    );
  }
  Map<String, dynamic> toJson() => {

    'notification': notification,
    'data': data,
  };

  @override
  String toString() {
    return '{notification: $notification, dataNotification: $data}';
  }
}