

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tchat_app/models/user_model.dart';

import 'firebase_database.dart';

//typedef Int2VoidFunc = void Function(UserModel userModel);
class FirebaseUpload{
  final void Function(UserModel userModel,bool success) callback;

  FirebaseUpload(this.callback);
  Future uploadFileAvatar(UserModel user,File avatarImageFile) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(FirebaseDataFunc(null).getStringPathAvatar(user.id));
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(user.id).update({// todo update row document user
            USER_PHOTO_URL: user.photoURL,
            USER_LAST_UPDATED: DateTime.now().millisecondsSinceEpoch.toString()
          }).then((data) async {
            user.photoURL = downloadUrl;
            callback(user,true);
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            callback(user,false);
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          callback(user,false);
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {

        callback(user,false);
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      callback(user,false);
      Fluttertoast.showToast(msg: err.toString());
    });
  }
  Future uploadFileCover(UserModel user,File avatarImageFile) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(FirebaseDataFunc(null).getStringPathCover(user.id));
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(user.id).update({// todo update row document user
            USER_COVER: user.cover,
            USER_LAST_UPDATED: DateTime.now().millisecondsSinceEpoch.toString()
          }).then((data) async {
            user.cover = downloadUrl;
            callback(user,true);
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            callback(user,false);
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          callback(user,false);
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {

        callback(user,false);
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      callback(user,false);
      Fluttertoast.showToast(msg: err.toString());
    });
  }
}