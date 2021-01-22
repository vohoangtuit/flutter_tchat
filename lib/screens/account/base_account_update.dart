import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tchat_app/base/generic_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/main.dart';
import 'package:tchat_app/models/account_model.dart';
import 'package:tchat_app/screens/dialogs/dialog_controller.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/camera_library_open.dart';
import 'package:tchat_app/utils/const.dart';

abstract class BaseAccountUpdate <T extends StatefulWidget> extends GenericAccountState {
 // TODO: this class using for screen update account implement more function

  void callBackCamera(File file, type);
  void callBackLibrary(File file, type);

  void updateProfile(AccountModel user,bool success);// todo create callback

  void saveAccountToDB(AccountModel user)async{// todo create callback
    await SharedPre.saveString(SharedPre.sharedPreUSer, jsonEncode(user));
    print('saveAccountToShared');

    await floorDB.getUserDao().findUserById(user.id).then((value)  {
      if(value==null){
        print('InsertUser');
        floorDB.getUserDao().InsertUser(user);
      }else{
        print('updateUser');
        floorDB.getUserDao().updateUser(user);
      }
    });
    if(mounted){
      ProviderController(context).setUserUpdated(true);
    }
   // getAccountFromSharedPre();
    getAccountFromFloorDB();
  }
  viewDialogPicture(int type, int choose) async{// todo type: 1 avatar,2 cover || choose : 1 take picture,2 library
    if(type==PICTURE_TYPE_AVATAR){
      if(choose ==CHOOSE_PICTURE_CAMERA){
        CameraLibraryOpening(callBackCamera).cameraOpen(type);
      }else if(choose ==CHOOSE_PICTURE_VIEW_PICTURE){
        await  Future.delayed(Duration.zero, () async {
          DialogController(context).ShowDialogViewSingleImage(dialog, account.photoURL);
        });
      }
      else{
        CameraLibraryOpening(callBackCamera).libraryOpen(type);
      }

    }else if(type==PICTURE_TYPE_COVER){
      if(choose ==CHOOSE_PICTURE_CAMERA){
        CameraLibraryOpening(callBackCamera).cameraOpen(type);
      }else if(choose ==CHOOSE_PICTURE_VIEW_PICTURE){
        Future.delayed(Duration.zero, () async {
          DialogController(context).ShowDialogViewSingleImage(dialog, account.cover);
        });
      }
      else{
        CameraLibraryOpening(callBackCamera).libraryOpen(type);
      }
    }
  }

  void updateUserAccount(AccountModel user){
    user.lastUpdated =DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseDataFunc(updateProfile).updateUserInfo(user);
  }
}
