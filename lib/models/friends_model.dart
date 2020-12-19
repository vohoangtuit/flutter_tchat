import 'package:cloud_firestore/cloud_firestore.dart';

final String FRIEND_MODEL = 'FriendModel';
final String FRIEND_ID = 'id';
final String FRIEND_FULLNAME = 'fullName';
final String FRIEND_PHOTO_URL  = 'photoURL';
final String FRIEND_STATUS_REQUEST  = 'statusRequest';

final int FRIEND_NOT_REQUEST =0;
final int FRIEND_SEND_REQUEST =1;
final int FRIEND_WAITING_CONFIRM =2;// show icon chat
final int FRIEND_SUCEESS =3;//// show icon chat
class FriendModel{
  String id;
  String fullName;
  String photoURL = '';
  int statusRequest=0;
  FriendModel({this.id, this.fullName, this.photoURL, this.statusRequest});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[FRIEND_ID] = this.id;
    data[FRIEND_FULLNAME] = this.fullName;
    data[FRIEND_PHOTO_URL] = this.photoURL;
    data[FRIEND_STATUS_REQUEST] = this.statusRequest;
    return data;
  }
  factory FriendModel.fromDocumentSnapshot (DocumentSnapshot doc) =>FriendModel(
      id: doc[FRIEND_ID],
      fullName: doc[FRIEND_FULLNAME],
      photoURL: doc[FRIEND_PHOTO_URL],
      statusRequest: doc[FRIEND_STATUS_REQUEST]
  );
  factory FriendModel.fromQuerySnapshot (QueryDocumentSnapshot doc) =>FriendModel(
      id: doc[FRIEND_ID],
      fullName: doc[FRIEND_FULLNAME],
      photoURL: doc[FRIEND_PHOTO_URL],
      statusRequest: doc[FRIEND_STATUS_REQUEST]
  );


  @override
  String toString() {
    return 'FriendModel{id: $id, fullName: $fullName, photoURL: $photoURL, statusRequest: $statusRequest}';
  }
}