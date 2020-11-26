
final String MESSAGE_ID ='id';
final String MESSAGE_ID_FROM ='idFrom';
final String MESSAGE_ID_TO ='idTo';
final String MESSAGE_TIMESTAMP ='timestamp';
final String MESSAGE_CONTENT ='content';
final String MESSAGE_TYPE ='type';
final String MESSAGE_STATUS ='status';
class Message{
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;
  int status;

  Message({this.idFrom, this.idTo, this.timestamp, this.content, this.type, this.status}){
    // this.idFrom =idFrom;
    // this.idTo =idTo;
    // this.timestamp =timestamp;
    // this.content =content;
    // this.type =type;
    // this.status =status;
  }
  Message.fromJson(Map<String, dynamic> json) {
    idFrom = json[MESSAGE_ID_FROM];
    idTo = json[MESSAGE_ID_TO];
    timestamp = json[MESSAGE_TIMESTAMP];
    content = json[MESSAGE_CONTENT];
    type = json[MESSAGE_TYPE];
    status = json[MESSAGE_STATUS];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[MESSAGE_ID_FROM] = this.idFrom;
    data[MESSAGE_ID_TO] = this.idTo;
    data[MESSAGE_TIMESTAMP] = this.timestamp;
    data[MESSAGE_CONTENT] = this.content;
    data[MESSAGE_TYPE] = this.type;
    data[MESSAGE_STATUS] = this.status;

    return data;
  }
}