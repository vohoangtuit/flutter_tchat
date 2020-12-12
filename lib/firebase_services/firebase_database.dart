import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tchat_app/models/message._model.dart';

final String FIREBASE_ID ='id';
final String FIREBASE_USERS ='users';
final String FIREBASE_MESSAGES ='messages';
final String FIREBASE_GROUP ='groups';

final String FIREBASE_STORE_PHOTO='photo';
final String FIREBASE_STORE_COVER='cover';
final String FIREBASE_STORE_AVATAR='avatar';

class FirebaseDatabaseMethods{
  String getStringPathAvatar(String uid){// user id
    //String fileName =DateTime.now().millisecondsSinceEpoch.toString();
    String avatar_ ='avatar_';// todo gán cứng name file, lần sau update ghi đè, ko cần xóa file củ
    return '/$uid'+'/'+FIREBASE_STORE_AVATAR+'/'+'$avatar_';
  }
  String getStringPathCover(String uid){// user id
   // String fileName =DateTime.now().millisecondsSinceEpoch.toString();
    String cover_ ='cover_';
    return '/$uid'+'/'+FIREBASE_STORE_COVER+'/'+'$cover_';
  }
  String getStringPathListPhoto(String uid){// user id
    String fileName =DateTime.now().millisecondsSinceEpoch.toString();
    return '/$uid'+'/'+FIREBASE_STORE_PHOTO+'/'+'$fileName';
  }

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
            .orderBy(MESSAGE_TIMESTAMP, descending: true)
            .limit(20)
            .snapshots();
  }
  getLastMessage(String idSender, String idReceiver)async{
    FirebaseFirestore.instance
        .collection(FIREBASE_MESSAGES)
        .doc(idSender)
        .collection(idReceiver)
        .limit(1)
        .orderBy(MESSAGE_TIMESTAMP, descending: true).snapshots();
  }

}