
import 'response_data.dart';
import 'notification_response.dart';

class ResponseNotification{
  NotificationResponse notification;
  DataResponse dataNotification;

  ResponseNotification({this.notification, this.dataNotification});

 // factory ResponseNotification.
  factory ResponseNotification.fromJson(Map<String, dynamic> json) => ResponseNotification(
    notification: json['notification'],
    dataNotification: json['data'],
  );
  Map<String, dynamic> toJson() => {
    'notification': notification,
    'data': dataNotification,
  };

  @override
  String toString() {
    return '{notification: $notification, dataNotification: $dataNotification}';
  }
}