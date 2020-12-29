class NotificationResponse{
  String title;
  String body;
  NotificationResponse({this.title, this.body});

  factory NotificationResponse.fromJson(Map<String, dynamic> json)=> NotificationResponse(
    title: json['notification']['title'],
    body: json['notification']['body']
  );
}