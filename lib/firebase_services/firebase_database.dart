import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/models/account_model.dart';

final String FIREBASE_ID ='id';

final String FIREBASE_NOTIFICATIONS ='notifications';
final String FIREBASE_USERS ='users';
final String FIREBASE_MESSAGES ='messages';
final String FIREBASE_GROUP ='groups';
final String FIREBASE_FRIENDS ='friends';

final String FIREBASE_STORE_PHOTO='photo';
final String FIREBASE_STORE_COVER='cover';
final String FIREBASE_STORE_AVATAR='avatar';

class FirebaseDataFunc{
  final void Function(AccountModel user,bool success) FBCallBack;
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
    print('idSender $idSender idReceiver $idReceiver');
    return await FirebaseFirestore.instance
        .collection(FIREBASE_MESSAGES)
            .doc( idSender)
            .collection(idReceiver)
            .orderBy(MESSAGE_TIMESTAMP, descending: true)
            .limit(20)
            .snapshots();
  }
chatListenerData(String myID,String toID){
    return FirebaseFirestore.instance
        .collection(FIREBASE_MESSAGES)
        .doc(myID)
        .collection(toID)
        .limit(1)
        .orderBy(MESSAGE_TIMESTAMP, descending: true);
}
  Future<DocumentSnapshot> getInfoUserProfile(String id)async{
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(id).get();
    return documentSnapshot;
  }
  Future<DocumentSnapshot> checkUserIsFriend(String idMe,String idFriend)async{
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS).doc(idMe).collection(idMe).doc(idFriend).get();
    return documentSnapshot;
  }
  getFriendsWithType(String myId,int type)async{
    return await FirebaseFirestore.instance.collection(FIREBASE_FRIENDS).doc(myId).collection(myId).where(FRIEND_STATUS_REQUEST,isEqualTo: type).get();
  }
  requestAddFriend(AccountModel myProfile,AccountModel user,FriendModel fromRequest,FriendModel toRequest){
    WriteBatch writeBatch =  FirebaseFirestore.instance.batch();
    DocumentReference from = FirebaseFirestore.instance.collection(FIREBASE_FRIENDS).doc(myProfile.id).collection(myProfile.id).doc(user.id); // todo: lấy user id làm id trên firebase
    //DocumentReference from = fireBaseStore.collection(FIREBASE_FRIENDS).doc(myProfile.id).collection(user.id).doc(user.id); // todo: lấy user id làm id trên firebase
    //DocumentReference from = fireBaseStore.collection(FIREBASE_FRIENDS).doc(myProfile.id).collection(user.id).doc();todo id tự generate on firebase
    DocumentReference to = FirebaseFirestore.instance.collection(FIREBASE_FRIENDS).doc(user.id).collection(user.id).doc(myProfile.id); // todo: lấy user id làm id trên firebase
    // DocumentReference to = fireBaseStore.collection(FIREBASE_FRIENDS).doc(user.id).collection(myProfile.id).doc(myProfile.id); // todo: lấy user id làm id trên firebase
    // DocumentReference to = fireBaseStore.collection(FIREBASE_FRIENDS).doc(user.id).collection(myProfile.id); todo id tự generate on firebase
    writeBatch.set(from, fromRequest.toJson());
    writeBatch.set(to, toRequest.toJson());
    return  writeBatch.commit();
  }
  acceptFriend(String myID, String userID)async{
    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    DocumentReference from = FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS)
        .doc(myID)
        .collection(myID)
        .doc(userID);
    DocumentReference to = FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS)
        .doc(userID)
        .collection(userID)
        .doc(myID);
    writeBatch.update(from, {FRIEND_STATUS_REQUEST: FRIEND_SUCEESS});
    writeBatch.update(to, {FRIEND_STATUS_REQUEST: FRIEND_SUCEESS});
    //return await writeBatch.commit();
    return  writeBatch.commit();
  }
  removeFriend(String myID, String userID)async{
    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    DocumentReference from = FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS)
        .doc(myID)
        .collection(myID)
        .doc(userID);
    DocumentReference to = FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS)
        .doc(userID)
        .collection(userID)
        .doc(myID);
    writeBatch.delete(from);
    writeBatch.delete(to);
    return  writeBatch.commit();
   // return  writeBatch;
  }
  void updateUserInfo(AccountModel user){
    FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(user.id).update({USER_FULLNAME:  user.fullName,USER_GENDER: user.gender,USER_BIRTHDAY:user.birthday,USER_LAST_UPDATED: user.lastUpdated
    }).then((data) async {
      FBCallBack(user,true);
      Fluttertoast.showToast(msg: "Update info success");
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }
}