import 'package:cloud_firestore/cloud_firestore.dart';

final String FIREBASE_ID ='id';
final String FIREBASE_USERS ='users';
final String FIREBASE_MESSAGES ='messages';
final String FIREBASE_GROUP ='groups';

class FirebaseDatabaseMethods{

  getAllUser()async{
    return await FirebaseFirestore.instance
        .collection(FIREBASE_USERS)
        .snapshots();
  }
  getMessageChat(String idSender, String idReceiver)async{
    return await FirebaseFirestore.instance
        .collection(FIREBASE_MESSAGES)
            .doc( idSender)
            .collection(idReceiver)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots();
  }

}