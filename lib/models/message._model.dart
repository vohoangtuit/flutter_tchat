
import 'package:floor/floor.dart';

final String MESSAGE_MESSAGE_MODEL ='MessageModel';
final String MESSAGE_ID ='id';

final String MESSAGE_ID_SENDER ='idSender';
final String MESSAGE_NAME_SENDER ='nameSender';
final String MESSAGE_PHOTO_SENDER ='photoSender';

final String MESSAGE_ID_RECEIVER ='idReceiver';
final String MESSAGE_NAME_RECEIVER ='nameReceiver';
final String MESSAGE_PHOTO_RECEIVER ='photoReceiver';

final String MESSAGE_TIMESTAMP ='timestamp';
final String MESSAGE_CONTENT ='content';
final String MESSAGE_TYPE ='type';
final String MESSAGE_STATUS ='status';
final String MESSAGE_GROUP_ID ='groupId';

@entity
class MessageModel{
  @PrimaryKey(autoGenerate: true)
  int idDB;
  String idSender='';
  String nameSender='';
  String photoSender='';
  String idReceiver='';
  String nameReceiver='';
  String photoReceiver='';
  String timestamp='';
  String content='';
  int type=0;//type: 0 = text, 1 = image, 2 = sticker
  int status=0;
  String groupId='';

  MessageModel({this.idDB,this.idSender,this.nameSender,this.photoSender, this.idReceiver,this.nameReceiver,this.photoReceiver, this.timestamp, this.content, this.type, this.status,this.groupId});

  MessageModel.fromJson(Map<String, dynamic> json) {
 //   id = json[MESSAGE_ID];
    idSender = json[MESSAGE_ID_SENDER];
    nameSender = json[MESSAGE_NAME_SENDER];
    photoSender = json[MESSAGE_PHOTO_SENDER];

    idReceiver = json[MESSAGE_ID_RECEIVER];
    nameReceiver = json[MESSAGE_NAME_RECEIVER];
    photoReceiver = json[MESSAGE_PHOTO_RECEIVER];

    timestamp = json[MESSAGE_TIMESTAMP];
    content = json[MESSAGE_CONTENT];
    type = json[MESSAGE_TYPE];
    status = json[MESSAGE_STATUS];
    groupId = json[MESSAGE_GROUP_ID];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[MESSAGE_ID_SENDER] = this.idSender;
    data[MESSAGE_NAME_SENDER] = this.nameSender;
    data[MESSAGE_PHOTO_SENDER] = this.photoSender;

    data[MESSAGE_ID_RECEIVER] = this.idReceiver;
    data[MESSAGE_NAME_RECEIVER] = this.nameReceiver;
    data[MESSAGE_PHOTO_RECEIVER] = this.photoReceiver;

    data[MESSAGE_TIMESTAMP] = this.timestamp;
    data[MESSAGE_CONTENT] = this.content;
    data[MESSAGE_TYPE] = this.type;
    data[MESSAGE_STATUS] = this.status;
    data[MESSAGE_GROUP_ID] = this.groupId;

    return data;
  }

  @override
  String toString() {
    return 'MessageModel{idDB: $idDB, idSender: $idSender, nameSender: $nameSender, photoSender: $photoSender, idReceiver: $idReceiver, nameReceiver: $nameReceiver, photoReceiver: $photoReceiver, timestamp: $timestamp, content: $content, type: $type, status: $status, groupId: $groupId}';
  }
}