import 'package:floor/floor.dart';
final String LAST_MESSAGE_ID_RECEIVER ='idReceiver';
final String LAST_MESSAGE_NAME_RECEIVER ='nameReceiver';
final String LAST_MESSAGE_PHOTO_RECEIVER ='photoReceiver';

final String LAST_MESSAGE_TIMESTAMP ='timestamp';
final String LAST_MESSAGE_CONTENT ='content';
final String LAST_MESSAGE_TYPE ='type';
final String LAST_MESSAGE_STATUS ='status';
@entity
class LastMessageModel{
  @PrimaryKey(autoGenerate: true)
  int idDB;
  String idReceiver='';
  String nameReceiver='';
  String photoReceiver='';
  String timestamp='';
  String content='';
  int type=0;//type: 0 = text, 1 = image, 2 = sticker
  int status=0;
  LastMessageModel({this.idDB,this.idReceiver,this.nameReceiver,this.photoReceiver,this.content,this.type,this.timestamp,this.status});

  LastMessageModel.fromJson(Map<String, dynamic> json){
    idReceiver = json[LAST_MESSAGE_ID_RECEIVER];
    nameReceiver = json[LAST_MESSAGE_NAME_RECEIVER];
    photoReceiver = json[LAST_MESSAGE_PHOTO_RECEIVER];
    content = json[LAST_MESSAGE_CONTENT];
    type = json[LAST_MESSAGE_TYPE];
    timestamp = json[LAST_MESSAGE_TIMESTAMP];
    status = json[LAST_MESSAGE_STATUS];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[LAST_MESSAGE_ID_RECEIVER] = this.idReceiver;
    data[LAST_MESSAGE_NAME_RECEIVER] = this.nameReceiver;
    data[LAST_MESSAGE_PHOTO_RECEIVER] = this.photoReceiver;

    data[LAST_MESSAGE_TIMESTAMP] = this.timestamp;
    data[LAST_MESSAGE_CONTENT] = this.content;
    data[LAST_MESSAGE_TYPE] = this.type;
    data[LAST_MESSAGE_STATUS] = this.status;

    return data;
  }
}