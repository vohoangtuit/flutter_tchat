import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/models/user_model.dart';

final String FIREBASE_ID ='id';
final String FIREBASE_USERS ='users';
final String FIREBASE_MESSAGES ='messages';
final String FIREBASE_GROUP ='groups';
final String FIREBASE_FRIENDS ='friends';

final String FIREBASE_STORE_PHOTO='photo';
final String FIREBASE_STORE_COVER='cover';
final String FIREBASE_STORE_AVATAR='avatar';

class FirebaseDataFunc{
  final void Function(UserModel user,bool success) FBCallBack;
  FirebaseDataFunc(this.FBCallBack);
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
  getFriend(String id)async{
    return await FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS)
        .doc( id)
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
  Future<DocumentSnapshot> checkUserIsFriend(String idMe,String idFriend)async{

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS).doc(idMe).collection(idMe).doc(idFriend).get();
    return documentSnapshot;
  }
  getAllFriends(String myId)async{
     FirebaseFirestore.instance.collection(FIREBASE_FRIENDS).doc(myId).collection(myId).where(FRIEND_STATUS_REQUEST,isEqualTo: FRIEND_SUCEESS).get();
  }
  void updateUserInfo(UserModel user){
    FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(user.id).update({USER_FULLNAME:  user.fullName,USER_GENDER: user.gender,USER_BIRTHDAY:user.birthday, USER_PHOTO_URL: user.photoURL
    }).then((data) async {
      FBCallBack(user,true);
      Fluttertoast.showToast(msg: "Update info success");
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }
}